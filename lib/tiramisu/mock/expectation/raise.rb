module Tiramisu
  class Mock
    class Expectation

      # ensure received message(s) raised as expected.
      #
      # @note if block given it will have precedence over arguments
      #
      # @example
      #   x = mock(X.new)
      #   expect(x).to_receive(:y).and_raise(NoMethodError)
      #   # call `x.y` for test to pass
      #
      def and_raise *expectations, &block
        @raise = if block
          block
        elsif @expected_messages.size > 1
          expectations.size == @expected_messages.size ||
            Kernel.raise(ArgumentError, "Wrong number of arguments, #{expectations.size} for #{@expected_messages.size}")
          expectations
        else
          [expectations]
        end
        self
      end

      def assert_message_raised_as_expected msg, i
        return unless @raise
        if @raise.is_a?(Proc)
          received_messages[msg].find {|log| @raise.call(msg, log[:raised])} || Tiramisu.fail([
            'Looks like :%s message never raised as expected' % msg,
            'See validation block'
          ], @caller)
        else
          source_location = Tiramisu.caller_to_source_location(@caller)
          received_messages[msg].each do |log|
            next unless f = Tiramisu.raised_as_expected?(log[:raised], source_location, *@raise[i])
            Tiramisu.fail(f, @caller)
          end
        end
      end
    end
  end
end
