require 'json'
require 'minitest/autorun'
require 'clover'

def proxy obj
  Clover::Assert.new(obj)
end
