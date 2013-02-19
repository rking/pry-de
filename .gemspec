# encoding: utf-8
require 'working/gemspec'
$:.unshift 'lib'
require 'pry-de'
require 'pry-de/version'

Working.gemspec(
  :name        => 'pry-de',
  :summary     => Working.third_line_of_readme,
  :description => Working.third_line_of_readme,
  :version     => PryDe::VERSION,
  :authors     => %w(☈king Banisterfiend),
  :email       => 'pry-de@sharpsaw.org',
  :github      => 'rking/pry-de',
  :deps        => %w(pry-full pry-fkeys guard),
)
