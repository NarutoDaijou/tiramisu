module Tiramisu
  class Mock

    # ensure received message(s) returns expected value(e)
    #
    # @example
    #   n = expect(1).to_receive(:+).with(1).and_return(2)
    #
    def and_return *values, &block
      @assert || Kernel.raise(StandardError, '`and_return` works only with positive assertions')
      values.any? && block && Kernel.raise(ArgumentError, 'both arguments and block given, please use either one')
      @return = if block
        block
      elsif @expected_messages.size > 1
        values.size == @expected_messages.size ||
          Kernel.raise(ArgumentError, "Wrong number of arguments, #{values.size} for #{@expected_messages.size}")
        values.all? {|x| x.is_a?(Array)} ||
          Kernel.raise(ArgumentError, 'Please provide expected return values as arrays, one array per expected message')
        values
      else
        values
      end
      self
    end

    private
    def __assert_message_returned_correct_value__ msg, i
      return unless @return
      if @return.is_a?(Proc)
        __received_messages__[msg].find {|log| @return.call(msg, log[:returned])} || Tiramisu.fail([
          'Looks like :%s message never returned expected value' % msg,
          'See validation block'
        ], @caller)
      else
        __received_messages__[msg].find {|log| log[:returned] == @return[i]} || Tiramisu.fail([
          'Looks like :%s message never returned expected value:' % msg,
          Tiramisu.pp(@return[i])
        ], @caller)
      end
    end
  end
end
