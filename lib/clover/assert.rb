module Clover
  class Assert

    def initialize object, action = :assert, block = nil, caller = nil
      @object = object
      @block  = block
      @caller = caller
      @assert = action == :assert
      @refute = action == :refute
    end

    instance_methods.each do |m|
      # overriding all instance methods so received messages to be passed to tested object.
      #
      # @example
      #   assert(x).frozen?
      #   # `assert` returns a object that receives `frozen?` message and pass it to x
      #
      define_method m do |*a, &b|
        __assert__(m, a, b)
      end
    end

    # forward any missing method to tested object.
    #
    # @example
    #   assert(some_array).include? x
    #   # object returned by `assert` does not respond to `include?`
    #   # so `include?` is passed to `some_array`
    #
    def method_missing m, *a, &b
      __assert__(m, a, b)
    end

    private
    def __assert__ message, arguments, block
      object = @block ? @block.call : @object
      result = __send_message__(object, message, arguments, block)
      return true if (@assert && result) || (@refute && !result)
      throw(:__clover_status__, Clover::AssertionFailure.new(object, arguments, @caller))
    end

    def __send_message__ object, message, arguments, block
      object.__send__(message, *arguments, &block)
    end
  end
end
