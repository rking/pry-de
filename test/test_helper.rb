#require 'pry-rescue'
require 'minitest/unit'
$:.unshift './lib'
#Pry.rescue do
  #begin
    MiniTest::Unit.autorun
  #rescue SystemExit => e
    #p e
  #end
#end
