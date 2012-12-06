# encoding: utf-8
module PryDe
  class BacktraceEdit
    class << self
      def interact
        warn green 'ZZ to hop to next, :cq to end.'
        trace.each do |e| edit e end
      rescue => e
        puts yellow e
      end

      def edit input
        hash = parse_line input
        path = hash[:path]
        unless File.exist? path
          return warn <<-EOT
From this line: '#{cyan input}'
parsed '#{yellow path}', which does not exist.
Assuming to not be a frame and, skipping
          EOT
        end
        viewer = vim_already_open_for(path) ? 'view' : 'vim'
        offset = ?+ + hash[:line]
        cmdheight = '+set cmdheight=2'
        msg = vim_message_for hash[:extra]
        warn blue "# #{hash[:extra]} ↴"
        recenter = '+norm zz'
        verbose_system viewer, path, cmdheight, msg, recenter, offset
        raise 'OK, done.' unless $?.success?
      end

      def trace
        require 'jist'
        trace = Jist.paste
        return trace_via_stdin if trace.empty? or not trace[/:in /]
        trace.split ?\n
      end

      def trace_via_stdin
        warn yellow 'Copy from clipboard not working.'
        warn cyan 'Paste manually, then hit ^d'
        STDIN.readlines
      end

      def vim_already_open_for path
        swpfile = "%s/.%s.swp" % [ File.dirname(path), File.basename(path) ]
        File.exist? swpfile
      end

      def vim_message_for str
        cleaned = str.gsub ?", '\\"'
        '+set ch=2|echo "%s"' % cleaned
      end

      def parse_line input
        input.chomp!
        r = Hash[[:path, :line, :extra].zip(input.split(?:, 3))]
        r[:path].sub! /^\s*from /, ''
        r
      end

      def verbose_system *args
        require 'shellwords'
        cmd = args.map(&:shellescape).join ' '
        warn cyan '    '+cmd
        system *args
      end

      def green str; color 32, str end
      def yellow str; color 33, str end
      def blue str; color 34, str end
      def cyan str; color 36, str end
      def color num, str
        "\e[#{num}m#{str}\e[0m" % [num, str]
      end
    end
  end
end
