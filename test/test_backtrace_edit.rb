require 'test_helper'

require 'pry-de/backtrace_edit'

class TestBacktraceEdit < MiniTest::Unit::TestCase
  def test_first_line_parse
    input = '/blah/src/scrap/foo.rb:4:in `jump\': foo (RuntimeError)'
    expected = {
      path: '/blah/src/scrap/foo.rb',
      line: '4',
      extra: 'in `jump\': foo (RuntimeError)'
    }
    actual = PryDe::BacktraceEdit.parse_line input
    assert_equal expected, actual
  end

  def test_line_parse_with_leading_from
    input = '     from /blah/src/scrap/foo.rb:6:in `block in buz\'`'
    expected = {
      path: '/blah/src/scrap/foo.rb',
      line: '6',
      extra: 'in `block in buz\'`'
    }
    actual = PryDe::BacktraceEdit.parse_line input
    assert_equal expected, actual
  end

  def test_a_bunch
    examples = <<EOT.split ?\n
/usr/lib64/ruby/1.9.1/drb/drb.rb:736:in `rescue in block in open'
/usr/lib64/ruby/1.9.1/drb/drb.rb:730:in `block in open'
/usr/lib64/ruby/1.9.1/drb/drb.rb:729:in `each'
/usr/lib64/ruby/1.9.1/drb/drb.rb:729:in `open'
/usr/lib64/ruby/1.9.1/drb/drb.rb:1191:in `initialize'
/usr/lib64/ruby/1.9.1/drb/drb.rb:1171:in `new'
/usr/lib64/ruby/1.9.1/drb/drb.rb:1171:in `open'
/usr/lib64/ruby/1.9.1/drb/drb.rb:1087:in `block in method_missing'
/usr/lib64/ruby/1.9.1/drb/drb.rb:1105:in `with_friend'
/usr/lib64/ruby/1.9.1/drb/drb.rb:1086:in `method_missing'
/usr/lib64/ruby/1.9.1/drb/drb.rb:1074:in `respond_to?'
/home/rking/.gem/ruby/1.9.1/gems/spork-0.9.2/lib/spork/run_strategy/forking.rb:10:in `block in run'
/home/rking/.gem/ruby/1.9.1/gems/spork-0.9.2/lib/spork/forker.rb:21:in `block in initialize'
/home/rking/.gem/ruby/1.9.1/gems/spork-0.9.2/lib/spork/forker.rb:18:in `fork'
/home/rking/.gem/ruby/1.9.1/gems/spork-0.9.2/lib/spork/forker.rb:18:in `initialize'
/home/rking/.gem/ruby/1.9.1/gems/spork-0.9.2/lib/spork/run_strategy/forking.rb:9:in `new'
/home/rking/.gem/ruby/1.9.1/gems/spork-0.9.2/lib/spork/run_strategy/forking.rb:9:in `run'
/home/rking/.gem/ruby/1.9.1/gems/spork-0.9.2/lib/spork/server.rb:48:in `run'
/usr/lib64/ruby/1.9.1/drb/drb.rb:1548:in `perform_without_block'
/usr/lib64/ruby/1.9.1/drb/drb.rb:1508:in `perform'
/usr/lib64/ruby/1.9.1/drb/drb.rb:1586:in `block (2 levels) in main_loop'
/usr/lib64/ruby/1.9.1/drb/drb.rb:1582:in `loop'
/usr/lib64/ruby/1.9.1/drb/drb.rb:1582:in `block in main_loop'`
EOT
    examples.each do |eg|
      assert PryDe::BacktraceEdit.parse_line(eg), "no-explode for '#{eg}'"
    end
  end
end
