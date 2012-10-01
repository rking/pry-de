require 'pry'

module PryDe

  def self.version_warny_input_pop _pry_
    fail 'Newer (possibly Github) pry needed' unless
      _pry_.input_array.respond_to? :pop!
    _pry_.input_array.pop!
  end

  Commands = Pry::CommandSet.new do
    def psuedo_alias dest, src
      command dest, "Alias for `#{src}`" do
        run src + ' ' + arg_string
      end
    end
    # pry-debugger shortcuts:
    psuedo_alias ',b', 'break'
    psuedo_alias ',s', 'step'
    psuedo_alias ',n', 'next'
    psuedo_alias ',c', 'continue'
    psuedo_alias ',f', 'finish'

    command ',loc', 'Show hash of local vars' do |*args|
      pry_vars = [
        :____, :___, :__, :_, :_dir_, :_file_, :_ex_, :_pry_, :_out_, :_in_ ]
      loc_names = target.eval('local_variables').reject do |e|
        pry_vars.include? e
      end
      name_value_pairs = loc_names.map do |name|
        [name, (target.eval name.to_s)]
      end
      name_value_pairs.sort! do |(a,av), (b,bv)|
        bv.to_s.size <=> av.to_s.size
      end
      Pry.print.call _pry_.output, Hash[name_value_pairs]
    end

    command ',-',
      'Remove last item from history, in preparation for a `play` command' do
      PryDe.version_warny_input_pop _pry_
    end

    command ',m', 'play method body only' do
      run_command 'play --lines 2..-2 -m'
    end

    # Hopefully this will be of diminished employment, as more direct routes
    # to the desired file:line grow, but for now it's a good all-purpose "edit"
    command ',lib', 'edit lib/' do
      run 'edit lib/'
      IO.popen('git status --porcelain -- lib').readlines.each do |dirty|
        entry = dirty.split(' ').last
        load entry if File.file? entry
      end
    end

    # alias_command ',r', 'hist --replay -1'

    command '?$', 'show-doc + show-source' do
      begin
        run '? ' + arg_string
      rescue Pry::CommandError => e
        output.puts text.bold('Behold: ') + e.message
      end
      run '$ ' + arg_string
    end

    # TODO: ,clip ⇒ cat -i; clipit -i $stdin.readline.chomp

    # ,, aliases all the ",cmd"s to "cmd". Undo with a second ",,"
    # I'll promise not to use x and y, so they can always be metasyntactic.
    # …but the rest are fair game.
    command ',,',
      'toggle ,-prefixes off/on commands, for terse input' do
      abbreviations = []
      commands.keys.reject do |cmd|
        cmd.class != String or cmd[0] != ',' or cmd == ',,'
      end.each do |e|
        terse = e[1..-1]
        # TODO: check to see if you're stomping on something, first.
        Pry.commands.alias_command terse, e
        abbreviations << terse
      end
      Pry.commands.command ',,', 'unsplat all ,-commands' do
        abbreviations.each do |too_terse|
          Pry.commands.delete too_terse
        end
      end
      Pry.output.puts "Added commands: #{abbreviations.join ' '}"
    end

    block_command /[$?]?\s*(.*?)\s*,,e\s*(.*)/,
      'edit from anywhere on the line' do |a,b|
      run "edit #{a} #{b}"
    end

    # I want this upstreamed as cat --EX
    command 'cat--EX', 'show whole backtrace' do
      ex = _pry_.last_exception
      count = ex.backtrace.count
      (0...count).each do |v|
        break if ex.backtrace[v].match /gems\/pry/
        run "cat --ex #{v}"
      end
    end

    # TODO: promote to pry-docmore.
    # Follow pry-doc further, e.g.:
    # $ [].push
    # C$ rb_ary_modify
    command 'C$', 'Hop to tag in the Ruby C source' do
      # TODO: Also check the dirs where rvm and ruby-build place trees.
      src_dir = ENV['RUBY_SRC_DIR'] || ENV['HOME']+'/pkg'
      unless Dir.exist? src_dir
        Pry.output.puts "Need either $RUBY_SRC_DIR (env var) or ~/pkg/ to exist"
        return
      end
      ruby_dir = src_dir + '/ruby'
      unless Dir.exist? ruby_dir
        Pry.output.puts "Need ruby source checkout."
        ruby_repo = 'https://github.com/ruby/ruby.git'
        Pry.output.puts \
          "Consider: .git clone --depth 1 #{ruby_repo} #{ruby_dir}"
          "(which takes <1min on a decent connection)"
      end
      Dir.chdir ruby_dir do
        unless File.exist? 'tags'
          puts "Building tags file with ctags -R"
          system 'ctags -R'
        end
        # Please let me know how to jump to a tag from your favorite $EDITOR
        system 'vim', '-t', arg_string
      end
    end

  end
end

Pry.config.commands.import PryDe::Commands
