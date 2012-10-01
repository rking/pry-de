module PryDe
  class BacktraceEdit
    def self.parse_line input
      r = Hash[[:file, :line, :method, :error].zip(input.split(?:))]
      r[:method].sub! /^in `(.+)'$/, '\1'
      r
    end
  end
end
