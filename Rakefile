# encoding: utf-8
require 'bundler/gem_tasks'

task default: :test
task :test do
  sh 'testrb test'
end

task :'pry-de' do
  sh *%w(bundle exec pry -Ilib -rpry-de) + ARGV[1..-1]
end

task :readme do
  sh 'erb README.md.erb >| README.md'
end
