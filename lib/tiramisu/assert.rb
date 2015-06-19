module Tiramisu
  class Assert
    BUNDLED_ASSERTIONS = {
      :raises  => true,
      'raises' => true,

      :to_raise  => true,
      'to_raise' => true,

      :throws  => true,
      'throws' => true,

      :to_throw  => true,
      'to_throw' => true
    }.freeze

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
      __expected_messages__.push([expected_messages, Mock.new(@object)]).last.last
    end
    alias to_receive receive

    class Mock
      def initialize object
        @object = object
      end

      instance_methods.each do |m|
        define_method m do |*a, &b|
          __register_and_send__(m, a, b)
        end
      end

      def method_missing m, *a, &b
        __register_and_send__(m, a, b)
      end

      def __received_messages__
        @__received_messages__ ||= {}
      end

      private
      def __register_and_send__ m, a, b
        (@__received_messages__[m] ||= []).push([a, b])
        @object.__send__(m, *a, &b)
      end
    end

    private
    def __expected_messages__
      @__expected_messages__ ||= []
    end

    def __assert__ message, arguments, block
      object = if BUNDLED_ASSERTIONS[message]
        @block || raise(ArgumentError, '%s expects a block' % message)
      else
        @block ? @block.call : @object
      end
      result = __send_message__(object, message, arguments, block)
      return true if (@assert && result) || (@refute && !result)
      throw(:__tiramisu_status__, Tiramisu::AssertionFailure.new(object, arguments, @caller))
    end

    def __send_message__ object, message, arguments, block
      if assertion = Tiramisu.assertions[message.to_sym]
        return assertion.call(object, *arguments, &block)
      end
      object.__send__(message, *arguments, &block)
    end
  end
end
