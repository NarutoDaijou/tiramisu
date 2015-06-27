module Tiramisu
  class Mock

    # ensure received message(s) raised as expected
    #
    # @example
    #   expect(:x).to_receive(:y).and_raise(NameError)
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
  end
end
