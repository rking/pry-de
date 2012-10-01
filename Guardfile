# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'minitest' do
  watch %r|^test/.*\/?test_.*\.rb|
  watch %r|^lib/pry-de/([^/]+)\.rb| do |m| "test/test_#{m[1]}.rb" end
  watch %r|^lib/pry-de.rb| do |m| "test/test_pry_de.rb" end
  watch %r|^test/test_helper\.rb| do 'test' end
end

# vim:ft=ruby
