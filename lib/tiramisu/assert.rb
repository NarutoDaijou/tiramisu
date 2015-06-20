module Tiramisu
  class Assert

    def initialize object, action = :assert, block = nil, caller = nil
      @object = object
      @block  = block
      @caller = caller
      @assert = action == :assert
      @refute = action == :refute
      @assert || @refute || raise(ArgumentError, 'action should be either :assert or :refute')
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

    # ensure the given block raises as expected
    #
    # @example assertion pass if block raises whatever
    #   assert {some code}.raise
    #
    # @example assertion pass if block raises NameError
    #   assert {some code}.raise NameError
    #
    # @example assertion pass if block raises NameError and error message matches /blah/
    #   assert {some code}.raise NameError, /blah/
    #
    # @example assertion pass if block raises whatever error that matches /blah/
    #   assert {some code}.raise nil, /blah/
    #
    # @example assertion pass if validation block returns a positive value
    #   assert {some code}.raise {|e| e.is_a?(NameError) && e.message =~ /blah/}
    #
    #
    # @example assertion pass if nothing raised
    #   refute {some code}.raise
    #   # same
    #   fail_if {some code}.raise
    #
    # @example assertion fails only if block raises a NameError.
    #   it may raise whatever but NameError. if nothing raised assertion will fail.
    #
    #   fail_if {some code}.raise NameError
    #
    # @example assertion pass if raised error does not match /blah/
    #   if nothing raised assertion will fail.
    #
    #   fail_if {some code}.raise nil, /blah/
    #
    # @example assertion will pass if raised error is not a NameError
    #   and error message does not match /blah/
    #   if nothing raised assertion will fail as well.
    #
    #   fail_if {some code}.raise NameError, /blah/
    #
    def raise type = nil, message = nil, &block
      failure = if @assert
        Tiramisu.assert_raised_as_expected(@block, type, message, block)
      else
        Tiramisu.refute_raised_as_expected(@block, type, message, block)
      end
      return true if failure.nil?
      Failures::Generic.new(Array(failure), @caller)
    end
    alias to_raise raise

    # ensure given block thrown as expected
    #
    def throw symbol = nil, value = nil, &block
      failure = Tiramisu.thrown_as_expected?(@block, symbol, value, block, @refute)
      return true if failure.nil?
      Failures::Generic.new(Array(failure), @caller)
    end

    # check the tested object receives given message(s)
    #
    # @example
    #   test :auth do
    #     user = assert(User.new).receive(:password)
    #     user.authenticate
    #     # by the end of test user should receive :password message, otherwise the test will fail
    #   end
    #
    # @example alternate syntax
    #   user = expect(User.new).to_receive(:password)
    #
    # @param [Symbol, Array] a message or a array of expected messages
    # @return [Mock]
    #
    def receive expected_messages
      __expected_messages__.push([Array(expected_messages), Mock.new(@object)]).last.last
    end
    alias to_receive receive

    def __validate_expected_messages__
      __expected_messages__.each do |(expected_messages,mock)|
        expected_messages.each do |expected_message|
          __validate_expected_message__(expected_message, mock)
        end
      end
    end

    private
    def __validate_expected_message__ expected_message, mock
      if @assert
        Kernel.throw(:__tiramisu_status__,
          Failures::ExpectedMessageNotReceived.new(expected_message, @object, @caller)
        ) unless mock.__received_messages__[expected_message]
      else
        Kernel.throw(:__tiramisu_status__,
          Failures::UnexpectedMessageReceived.new(expected_message, @object, @caller)
        ) if mock.__received_messages__[expected_message]
      end
    end

    def __expected_messages__
      @__expected_messages__ ||= []
    end

    def __assert__ message, arguments, block
      object = @block ? @block.call : @object
      result = __send_message__(object, message, arguments, block)
      return true if (@assert && result) || (@refute && !result)
      Kernel.throw(:__tiramisu_status__, Failures::Assertion.new(object, arguments, @caller))
    end

    def __send_message__ object, message, arguments, block
      if assertion = Tiramisu.assertions[message.to_sym]
        return assertion.call(object, *arguments, &block)
      end
      object.__send__(message, *arguments, &block)
    end
  end
end
