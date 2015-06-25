module Tiramisu
  class Mock

    # @example
    #   test :some_test do
    #     mock = assert(some_object).receive(:some_method).with(:some, :args)
    #     # call `mock.some_method(:some, :args)` for test to pass
    #   end
    #
    def with *args, &block
      @assert || Kernel.raise(StandardError, '`with` works only with positive assertions')
      args.any? && block && Kernel.raise(ArgumentError, 'both arguments and block given, please use either one')
      @with = if block
        block
      elsif @expected_messages.size > 1
        args.size == @expected_messages.size ||
          Kernel.raise(ArgumentError, "Wrong number of arguments, #{args.size} for #{@expected_messages.size}")
        args.all? {|x| x.is_a?(Array)} ||
          Kernel.raise(ArgumentError, 'Please provide expected arguments as arrays, one array per expected message')
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
