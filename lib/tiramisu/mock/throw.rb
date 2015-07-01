module Tiramisu
  class Mock

    # ensure received message(s) throws expected symbol(s)/value(s)
    #
    # @example
    #   x = expect(x).to_receive(:y).and_throw(:z)
    #
    def and_throw *expectations, &block
      @assert || Kernel.raise(StandardError, '`and_throw` works only with positive assertions')
      expectations.any? && block && Kernel.raise(ArgumentError, 'both arguments and block given, please use either one')
      @throw = if block
        block
      elsif @expected_messages.size > 1
        expectations.size == @expected_messages.size ||
          Kernel.raise(ArgumentError, "Wrong number of arguments, #{expectations.size} for #{@expected_messages.size}")
        Array(expectations)
      else
        [Array(expectations)]
      end
      self
    end

    def __assert_message_thrown_as_expected__ msg, i
      return unless @throw
      if @throw.is_a?(Proc)
        __received_messages__[msg].find {|log| @throw.call(msg, log[:thrown])} || Tiramisu.fail([
          'Looks like :%s message never thrown expected symbol/value' % msg,
          'See validation block'
        ], @caller)
      else
        source_location = Tiramisu.caller_to_source_location(@caller)
        __received_messages__[msg].each do |log|
          next unless f = Tiramisu.thrown_as_expected?(@throw[i], log[:thrown], source_location)
          Tiramisu.fail(f, @caller)
        end
      end
    end
  end
end
