assert :throws do |proc, expected_symbol, expected_value|
  thrown_symbol, thrown_value = Tiramisu.catch_symbol(proc, expected_symbol)
  if expected_symbol
    unless expected_symbol == thrown_symbol
      with = ['Expected the block at %s:%s to throw :%s symbol' % [*Tiramisu.relative_source_location(proc), expected_symbol]]
      with << 'Instead :%s symbol thrown' % thrown_symbol if thrown_symbol
      fail(*with)
    end
  end
  if expected_value
    regexp = expected_value.is_a?(Regexp) ? expected_value : /\A#{expected_value}\z/
    unless thrown_value.to_s =~ regexp
      with = ['The block at %s:%s thrown :%s symbol with a wrong value' % [*Tiramisu.relative_source_location(proc), thrown_symbol]]
      with << 'Expected value: %s' % expected_value.inspect
      with << '  Thrown value: %s' % thrown_value.inspect
      fail(*with)
    end
  end
  true
end
