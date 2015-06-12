require 'json'
require 'minitest/autorun'
require 'clover'

def proxy obj
  Clover::Assert.new(obj)
end

def mock meth, *args, &block
  m = Minitest::Mock.new
  m.expect(meth, true, args, &block)
  proxy(m)
end
