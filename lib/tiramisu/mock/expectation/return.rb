module Tiramisu
  class Mock
    class Expectation

      # ensure received message(s) returns expected value(e)
      #
      # @note if block given it will have precedence over arguments
      #
      # @example
      #   n = expect(1).to_receive(:+).with(1).and_return(2)
      #
      def and_return *values, &block
        @return = if block
          block
        elsif @expected_messages.size > 1
          values.size == @expected_messages.size ||
            Kernel.raise(ArgumentError, "Wrong number of arguments, #{values.size} for #{@expected_messages.size}")
          values
        else
          values
        end
        self
      end

      private
      def assert_message_returned_correct_value msg, i
        return unless @return
        if @return.is_a?(Proc)
          received_messages[msg].find {|log| @return.call(msg, log[:returned])} || Tiramisu.fail([
            'Looks like :%s message never returned expected value' % msg,
            'See validation block'
          ], @caller)
        else
          received_messages[msg].find {|log| log[:returned] == @return[i]} || Tiramisu.fail([
            'Looks like :%s message never returned expected value:' % msg,
            Array(@return[i]).map {|x| Tiramisu.pp(x)}.join(', ')
          ], @caller)
        end
      end
    end
  end
end
