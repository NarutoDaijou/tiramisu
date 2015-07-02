module Tiramisu
  class Mock

    # ensure message(s) received with expected arguments
    #
    # @note if block given it will have precedence over arguments
    #
    # @example
    #   test :some_test do
    #     some_object = mock(SomeObject.new)
    #     expect(some_object).to_receive(:some_method).with(:some, :args)
    #     # call `some_object.some_method(:some, :args)` for test to pass
    #   end
    #
    def with *args, &block
      args.map! {|x| Array(x)}
      @with = if block
        block
      elsif @expected_messages.size > 1
        args.size == @expected_messages.size ||
          Kernel.raise(ArgumentError, "Wrong number of arguments, #{args.size} for #{@expected_messages.size}")
        args
      else
        [args]
      end
      self
    end

    private
    def __assert_message_received_with_correct_arguments__ msg, i
      return unless @with
      if @with.is_a?(Proc)
        __received_messages__[msg].find {|log| @with.call(msg, log[:arguments])} || Tiramisu.fail([
          'Looks like :%s message never was called with expected arguments' % msg,
          'See validation block'
        ], @caller)
      else
        __received_messages__[msg].find {|log| log[:arguments] == @with[i]} || Tiramisu.fail([
          'Looks like :%s message never was called with expected arguments:' % msg,
          Array(@with[i]).map {|x| Tiramisu.pp(x)}.join(', ')
        ], @caller)
      end
    end
  end
end
