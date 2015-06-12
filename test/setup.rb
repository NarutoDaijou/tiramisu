require 'json'
require 'minitest/autorun'
require 'clover'

module Minitest
  class Mock
    def respond_to?(sym, include_private = false)
      retval = __respond_to?(sym, include_private)
      if @expected_calls.key?(:respond_to?)
        @actual_calls[:respond_to?] << {retval: retval, args: [sym, include_private]}
      end
      retval
    end
  end
end

def proxy obj
  Clover::Assert.new(obj)
end

def mock meth, *args, &block
  m = Minitest::Mock.new
  m.expect(meth, true, args, &block)
  proxy(m)
end
