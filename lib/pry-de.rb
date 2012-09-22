require 'pry'

module PryDe

  Commands = Pry::CommandSet.new do
    # pry-debugger shortcuts:
    Pry.commands.alias_command ',b', 'break'
    Pry.commands.alias_command ',s', 'step'
    Pry.commands.alias_command ',n', 'next'
    Pry.commands.alias_command ',c', 'continue'
    Pry.commands.alias_command ',f', 'finish'

    Pry.commands.command ',loc' do |*args|
      pry_vars = [
        :____, :___, :__, :_, :_dir_, :_file_, :_ex_, :_pry_, :_out_, :_in_ ]
      loc_names = target.eval('local_variables').reject do |e|
        pry_vars.include? e
      end
      name_value_pairs = loc_names.map do |name|
        [name, (target.eval name.to_s)]
      end
      require 'pry';binding.pry
      name_value_pairs.sort! do |(a,av), (b,bv)|
        bv.to_s.size <=> av.to_s.size
      end
      Pry.print.call _pry_.output, Hash[name_value_pairs]
    end

    Pry.commands.command ',-',
      'Remove last item from history, in preparation for a `play` command' do
      fail 'Newer (possibly Github) pry needed' unless
        _pry_.input_array.respond_to? :pop!
      _pry_.input_array.pop!
    end

    Pry.commands.command ',m', 'play method body only' do
      run_command 'play --lines 2..-2 -m'
    end

    # Hopefully this will be of diminished employment, as more direct routes
    # to the desired file:line grow, but for now it's a good all-purpose "edit"
    Pry.commands.command ',lib', 'edit lib/' do
      run 'edit lib/'
      IO.popen('git status --porcelain -- lib').readlines.each do |dirty|
        load dirty.split(' ').last
      end
    end

    Pry.commands.command ',r', 'Rerun previous command, like "r" in zsh' do
      run 'history --replay -1'
    end

    Pry.commands.command '?$', 'show-doc + show-source' do
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
    Pry.commands.command ',,',
      'toggle ,-prefixes off/on commands, for terse input' do
      abbreviations = []
      Pry.commands.commands.keys.reject do |cmd|
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

    Pry.commands.block_command /[$?]?\s*(.*?)\s*,,e\s*(.*)/,
      'edit from anywhere on the line' do |a,b|
      run "edit #{a} #{b}"
    end

    # I want this upstreamed as cat --EX
    Pry.commands.command 'cat--EX', 'show whole backtrace' do
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
    Pry.commands.command 'C$', 'Hop to tag in the Ruby C source' do
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
