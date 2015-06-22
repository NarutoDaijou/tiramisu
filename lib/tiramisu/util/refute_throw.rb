module Tiramisu

  def refute_thrown_as_expected proc, expected_symbol, expected_value
    thrown_symbol, thrown_value = Tiramisu.catch_symbol(proc, expected_symbol)
    source_location = Tiramisu.relative_source_location(proc)

    f = refute_thrown(thrown_symbol, source_location, expected_symbol || expected_value)
    return f if f

    if expected_symbol
      f = refute_expected_symbol_thrown(thrown_symbol, expected_symbol, source_location)
      return f if f
    end

    if expected_value
      f = refute_expected_value_thrown(thrown_value, expected_value, source_location)
      return f if f
    end
    nil
  end

  def refute_thrown thrown_symbol, source_location, should_throw = false
    if should_throw
      return [
        'Expected a symbol to be thrown at %s:%s' % source_location
      ] unless thrown_symbol
    else
      return [
        'Not expected a symbol to be thrown at %s:%s' % source_location
      ] if thrown_symbol
    end
    nil
  end

  def refute_expected_symbol_thrown thrown_symbol, expected_symbol, source_location
    return [
      'Not expected %s to be thrown' % expected_symbol.inspect,
      'at %s:%s' % source_location
    ] if expected_symbol == thrown_symbol
    nil
  end

  def refute_expected_value_thrown thrown_value, expected_value, source_location
    regexp = expected_value.is_a?(Regexp) ? expected_value : /\A#{expected_value}\z/
    return [
      'Not expected value thrown at %s:%s' % source_location,
      'to match %s' % thrown_value.inspect
    ] if thrown_value.to_s =~ regexp
    nil
  end
end
