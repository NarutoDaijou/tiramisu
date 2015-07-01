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

  end
end
