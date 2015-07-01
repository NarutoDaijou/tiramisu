module Tiramisu

  def assert_thrown_as_expected proc, expected_symbol, expected_value
    thrown_symbol, thrown_value = Tiramisu.catch_symbol(proc, expected_symbol)
    thrown_as_expected?(
      expected_symbol,
      expected_value,
      thrown_symbol,
      thrown_value,
      Tiramisu.relative_source_location(proc)
    )
  end

  def thrown_as_expected? expected_symbol, expected_value, thrown_symbol, thrown_value, source_location
    f = assert_thrown(thrown_symbol, source_location)
    return f if f

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
    return [
      'Expected a symbol to be thrown at %s:%s' % source_location
    ] unless thrown_symbol
    nil
  end

  def assert_expected_symbol_thrown thrown_symbol, expected_symbol, source_location
    return begin
      failure = ['Expected %s to be thrown at %s:%s' % [expected_symbol.inspect, *source_location]]
      failure << 'Instead %s thrown' % thrown_symbol.inspect if thrown_symbol
      failure
    end unless expected_symbol == thrown_symbol
    nil
  end

  def assert_expected_value_thrown thrown_value, expected_value, source_location
    regexp = expected_value.is_a?(Regexp) ? expected_value : /\A#{expected_value}\z/
    return [
      'Wrong value thrown at %s:%s' % source_location,
      'Expected value: %s' % expected_value.inspect,
      '  Thrown value: %s' % thrown_value.inspect
    ] unless thrown_value.to_s =~ regexp
    nil
  end
end
