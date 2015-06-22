module Tiramisu

  def assert_thrown_as_expected proc, expected_symbol, expected_value, block
    thrown_symbol, thrown_value = Tiramisu.catch_symbol(proc, expected_symbol)
    source_location = Tiramisu.relative_source_location(proc)

    f = assert_thrown(thrown_symbol, source_location)
    return f if f

    # validation by block would be ambiguous here
    # cause to get thrown value we need to know the expected symbol
    # which should be passed as argument and we can pass either argument(s) or block, not both

    if expected_symbol
      f = assert_expected_symbol_thrown(thrown_symbol, expected_symbol, source_location)
      return f if f
    end

    if expected_value
      f = assert_expected_value_thrown(thrown_value, expected_value, source_location)
      return f if f
    end
    nil
  end

  def assert_thrown thrown_symbol, source_location
    return if thrown_symbol
    'Expected a symbol to be thrown at %s:%s' % source_location
  end

  def assert_expected_symbol_thrown thrown_symbol, expected_symbol, source_location
    return if expected_symbol == thrown_symbol
    failure = ['Expected %s to be thrown at %s:%s' % [expected_symbol.inspect, *source_location]]
    failure << 'Instead %s thrown' % thrown_symbol.inspect if thrown_symbol
    failure
  end

  def assert_expected_value_thrown thrown_value, expected_value, source_location
    regexp = expected_value.is_a?(Regexp) ? expected_value : /\A#{expected_value}\z/
    return if thrown_value.to_s =~ regexp
    [
      'Wrong value thrown at %s:%s' % source_location,
      'Expected value: %s' % expected_value.inspect,
      '  Thrown value: %s' % thrown_value.inspect
    ]
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
