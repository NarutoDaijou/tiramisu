module Tiramisu
  class Assert

    def initialize object, action = :assert, block = nil, caller = nil
      @object = object
      @block  = block
      @caller = caller
      @assert = action == :assert
      @refute = action == :refute
      @assert || @refute || Kernel.raise(ArgumentError, 'action should be either :assert or :refute')
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
      if block && (type || message)
        Kernel.raise(ArgumentError, 'Both arguments and a block given, please use either one')
      end
      failure = if @assert
        Tiramisu.assert_raised_as_expected(@block, type, message, block)
      else
        Tiramisu.refute_raised_as_expected(@block, type, message, block)
      end
      Tiramisu.fail(failure, @caller) if failure
    end
    alias to_raise raise

    # ensure given block thrown as expected
    #
    # @example assertion pass if any symbol thrown
    #   assert {some code}.throw
    #
    # @example assertion pass only if :x symbol thrown
    #   assert {some code}.throw(:x)
    #
    # @example assertion pass only if :x symbol with :y value thrown
    #   assert {some code}.throw(:x, :y)
    #
    # @example assertion pass only if :x symbol with a value that match /y/ thrown
    #   assert {some code}.throw(:x, /y/)
    #
    # @example assertion pass when any symbol thrown with :y value
    #   assert {some code}.throw(nil, :y)
    #
    # @example assertion pass when any symbol thrown with a value that match /y/ thrown
    #   assert {some code}.throw(nil, /y/)
    #
    def throw symbol = nil, value = nil, &block
      if block
        # validation by block would be ambiguous here
        # cause to get thrown value we need to know the expected symbol which should be passed as argument
        # and accepting both arguments and block would be confusing
        Kernel.raise(ArgumentError, '`throw` does not accept a block')
      end
      failure = if @assert
        Tiramisu.assert_thrown_as_expected(@block, symbol, value)
      else
        Tiramisu.refute_thrown_as_expected(@block, symbol, value)
      end
      Tiramisu.fail(failure, @caller) if failure
    end
    alias to_throw throw

    # ensure given mock will receive expected message(s) by the end of test
    #
    # @example
    #   test :auth do
    #     user = mock(User.new)
    #     expect(user).to_receive(:password)
    #     user.authenticate
    #     # by the end of test user should receive :password message,
    #     # otherwise the test will fail
    #   end
    #
    # @param [Symbol, Array] a message or a array of expected messages
    # @return [Mock]
    #
    def receive *expected_messages
      mock = @block ? @block.call : @object
      mock.__expected_messages__ rescue Kernel.raise(ArgumentError, '`receive` only works with predefined mocks')
      expected_messages.any? || Kernel.raise(ArgumentError, 'Wrong number of arguments, 0 for 1+')
      expected_messages.map!(&:to_sym)
      if @assert
        mock.__expected_messages__.push(expected_messages)
      else
        mock.__unexpected_messages__.push(expected_messages)
      end
      mock
    end
    alias to_receive receive

    private
    def __assert__ message, arguments, block
      object = @block ? @block.call : @object
      result = __send_message__(object, message, arguments, block)
      return true if (@assert && result) || (@refute && !result)
      Kernel.throw(:__tiramisu_status__, AssertionFailure.new(object, arguments, @caller))
    end

    def __send_message__ object, message, arguments, block
      if assertion = Tiramisu.assertions[message.to_sym]
        return assertion.call(object, *arguments, &block)
      end
      object.__send__(message, *arguments, &block)
    end
  end
end
