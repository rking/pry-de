require 'pry'

module PryDe

  Commands = Pry::CommandSet.new do
    Pry.commands.alias_command ',b', 'break'
    Pry.commands.alias_command ',s', 'step'
    Pry.commands.alias_command ',n', 'next'
    Pry.commands.alias_command ',c', 'continue'
    Pry.commands.alias_command ',f', 'finish'

    # Good for cleaning up prior to `play -i 2..5` and such
    Pry.commands.command ',-', 'Remove last item from history' do
      fail 'Newer (possibly Github) pry needed' unless
        _pry_.input_array.respond_to? :pop!
      _pry_.input_array.pop!
    end

    Pry.commands.command ',m', 'play method body only' do
      run_command 'play --lines 2..-2 -m'
    end

    # Hackish, but comes in handy due to vim's :Ex
    Pry.commands.alias_command ',l', 'edit lib'

    Pry.commands.command ',r', 'Rerun previous command, like in zsh' do
      run 'history --replay -1'
    end

    # ,, aliases all the ",cmd"s to "cmd". Undo with a second ",,"
    # I'll promise not to use x and y, so they can always be metasyntactic.
    # …but the rest are fair game.
    Pry.commands.command ',,', 'splat all ,-commands into ,-unadornedness' do
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
