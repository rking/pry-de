module PryDe
  class BacktraceEdit
    class << self
      def parse_line input
        r = Hash[[:file, :line, :method, :error].zip(input.split(?:))]
        r[:method].sub! /^in `(.+)'$/, '\1'
        r
      end
    end
  end
end
