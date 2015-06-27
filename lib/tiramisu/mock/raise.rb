module Tiramisu
  class Mock

    # ensure received message(s) raised as expected
    #
    # @example
    #   x = expect(:x).to_receive(:y).and_raise(NoMethodError)
    #   # call `x.y` for test to pass
    #
    def and_raise *expectations, &block
      @assert || Kernel.raise(StandardError, '`and_raise` works only with positive assertions')
      expectations.any? && block && Kernel.raise(ArgumentError, 'both arguments and block given, please use either one')
      @raise = if block
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

    def __assert_message_raised_as_expected__ msg, i
      return unless @raise
      if @raise.is_a?(Proc)
        __received_messages__[msg].find {|log| @raise.call(msg, log[:raised])} || Tiramisu.fail([
          'Looks like :%s message never raised as expected' % msg,
          'See validation block'
        ], @caller)
      else
        source_location = Tiramisu.caller_to_source_location(@caller)
        __received_messages__[msg].each do |log|
          next unless f = Tiramisu.raised_as_expected?(log[:raised], source_location, *@raise[i])
          Tiramisu.fail(f, @caller)
        end
      end
    end
  end
end
