require 'test_helper'
require 'pry-de/backtrace_edit'

class TestBacktraceEdit < MiniTest::Unit::TestCase
  def test_first_line_parse
    input = '/blah/src/scrap/foo.rb:4:in `jump\': foo (RuntimeError)'
    expected = {
      file: '/blah/src/scrap/foo.rb',
      line: '4',
      method: 'jump',
      error: ' foo (RuntimeError)'
    }
    actual = PryDe::BacktraceEdit.parse_line input
    assert_equal expected, actual
  end
end
