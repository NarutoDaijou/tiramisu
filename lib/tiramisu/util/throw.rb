module Tiramisu

  def thrown_as_expected? proc, expected_symbol, expected_value, block, negate
    thrown_symbol, thrown_value = Tiramisu.catch_symbol(proc, expected_symbol)
    if expected_symbol
      unless expected_symbol == thrown_symbol
        failure = ['Expected the block at %s:%s to throw :%s symbol' % [*Tiramisu.relative_source_location(proc), expected_symbol]]
        failure << 'Instead :%s symbol thrown' % thrown_symbol if thrown_symbol
        return failure
      end
    end
    if expected_value
      regexp = expected_value.is_a?(Regexp) ? expected_value : /\A#{expected_value}\z/
      unless thrown_value.to_s =~ regexp
        failure = ['The block at %s:%s thrown :%s symbol with a wrong value' % [*Tiramisu.relative_source_location(proc), thrown_symbol]]
        failure << 'Expected value: %s' % expected_value.inspect
        failure << '  Thrown value: %s' % thrown_value.inspect
        return failure
      end
    end
    nil
  end

  # call given block and catch thrown symbol, if any
  #
  # @param [Proc] block
  # @param [Symbol] expected_symbol
  #
  def catch_symbol block, expected_symbol
    thrown_symbol, thrown_value = nil
    begin
      if expected_symbol
        thrown_value = catch :__tiramisu__nothing_thrown do
          catch expected_symbol do
            block.call
            throw :__tiramisu__nothing_thrown, :__tiramisu__nothing_thrown
          end
        end
        thrown_symbol = expected_symbol unless thrown_value == :__tiramisu__nothing_thrown
      else
        block.call
      end
    rescue => e
      raise(e) unless thrown_symbol = extract_thrown_symbol(e)
    end
    [thrown_symbol, thrown_value]
  end

  # extract thrown symbol from given exception
  #
  # @param exception
  #
  def extract_thrown_symbol exception
    return unless exception.is_a?(Exception)
    return unless s = exception.message.scan(/uncaught throw\W+(\w+)/).flatten[0]
    s.to_sym
  end
end
