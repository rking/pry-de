module PryDe
  class BacktraceEdit
    class << self
      def interact
        warn 'Exit your editor (e.g. :cq from vim) with nonzero to stop early.'
        trace.each do |e| edit e end
      end

      def edit input
        p input
        hash = parse_line input
        path = hash[:path]
        unless File.exist? path
          return warn <<-EOT
From this line: '#{input}'
parsed '#{path}' does not exist.
Assuming to not be a frame and, skipping
          EOT
        end
        viewer = vim_already_open_for(path) ? 'view' : 'vim'
        verbose_system viewer, path, ?+ + hash[:line]
        fail unless $?.success?
      end

      def trace
        require 'jist'
        trace = Jist.paste
        return trace_via_stdin if trace.empty? or not trace[/:in /]
        trace.split ?\n
      end

      def trace_via_stdin
        warn 'Copy from clipboard not working. Paste manually then ^d it:'
        STDIN.readlines
      end

      def vim_already_open_for path
        swpfile = "%s/.%s.swp" % [ File.dirname(path), File.basename(path) ]
        p :checking, swpfile
        File.exist? swpfile
      end

      def parse_line input
        r = Hash[[:path, :line, :extra].zip(input.split(?:, 3))]
        r[:path].sub! /^\s*from /, ''
        r
      end

      def verbose_system *args
        puts args.join ' '
        system *args
      end
    end
  end
end
