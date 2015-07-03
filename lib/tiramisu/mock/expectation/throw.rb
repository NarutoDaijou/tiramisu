module Tiramisu
  class Mock
    class Expectation

      # ensure received message(s) throws expected symbol(s)/value(s)
      #
      # @note if block given it will have precedence over arguments
      #
      # @example
      #   x = mock(X.new)
      #   expect(x).to_receive(:y).and_throw(:z)
      #
      def and_throw *expectations, &block
        @throw = if block
          block
        elsif @expected_messages.size > 1
          expectations.size == @expected_messages.size ||
            Kernel.raise(ArgumentError, "Wrong number of arguments, #{expectations.size} for #{@expected_messages.size}")
          expectations
        else
          expectations
        end
        self
      end

      def assert_message_thrown_as_expected msg, i
        return unless @throw
        if @throw.is_a?(Proc)
          received_messages[msg].find {|log| @throw.call(msg, log[:thrown])} || Tiramisu.fail([
            'Looks like :%s message never thrown expected symbol/value' % msg,
            'See validation block'
          ], @caller)
        else
          source_location = Tiramisu.caller_to_source_location(@caller)
          received_messages[msg].each do |log|
            next unless f = Tiramisu.thrown_as_expected?([@throw[i]], [log[:thrown]], source_location)
            Tiramisu.fail(f, @caller)
          end
        end
      end
    end
  end
end
