# encoding: utf-8

require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = 'pry-de'
  gem.homepage = 'http://github.com/rking/pry-de'
  gem.license = 'MIT'
  gem.summary = %Q{Run-time Ruby Development Environment based on Pry. [Maturity: Fœtal. Only use if you're adventurous]}
  gem.description = %Q{For the concept, see: https://github.com/pry/pry/wiki/pry-de}
  gem.email = 'pry-de@sharpsaw.org'
  gem.authors = ['☈king']
end
Jeweler::RubygemsDotOrgTasks.new

task :default => :spec

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

#require 'yard'
#YARD::Rake::YardocTask.new

task :install do
  Rake::Task['gemspec'].invoke
  sh 'gem build *.gemspec'
  sh 'gem install *.gem'
end
