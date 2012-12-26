# encoding: utf-8
lib = File.expand_path '../lib', __FILE__
$:.unshift lib unless $:.include? lib
require 'pry-de/version'

Gem::Specification.new do |gem|
  gem.name = 'pry-de'
  gem.homepage = 'http://github.com/rking/pry-de'
  gem.summary = %Q{Run-time Ruby Development Environment based on Pry. [Maturity: Fœtal. Only use if you're adventurous]}
  gem.description = %Q{For the concept, see: https://github.com/pry/pry/wiki/pry-de}
  gem.version = PryDe::VERSION
  gem.license = 'CC0'
  gem.email = 'pry-de@sharpsaw.org'
  gem.authors = %w(☈king Banisterfiend)

  gem.files = `git ls-files`.split $/
  gem.executables = gem.files.grep(%r{^bin/}).map{ |f| File.basename f }
  gem.test_files = gem.files.grep %r{^(test|spec|features)/}
  gem.require_paths = %w(lib)
  %w(pry-full guard).each do |dep| gem.add_dependency dep end
end
