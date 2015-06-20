module Tiramisu

  # call the given block and check whether it raised any exception.
  # if everything raised as expected return nil,
  # otherwise return a failure
  def assert_raised_as_expected proc, expected_type, expected_message, block
    e = nil
    begin
      proc.call
    rescue Exception => e
    end
    source_location = Tiramisu.relative_source_location(proc)

    f = assert_raised(e, source_location)
    return f if f

    if block
      f = assert_raised_as_expected_by_block(e, block, source_location)
      return f if f
    end

    if expected_type
      f = assert_raised_expected_type(e.class, expected_type, source_location)
      return f if f
    end

    if expected_message
      f = assert_raised_expected_message(e.message, expected_message, source_location)
      return f if f
    end
    nil
  end

  def assert_raised x, source_location
    return [
      'Expected a exception to be raised at %s:%s' % source_location
    ] unless x.is_a?(Exception)
    nil
  end

  def assert_raised_as_expected_by_block exception, block, source_location
    return [
      'Looks like the block at %s:%s did not raise as expected' % source_location,
      'Check validation block'
    ] unless block.call(exception)
    nil
  end

  def assert_raised_expected_type type, expected_type, source_location
    return [
      'Expected a %s to be raised at %s:%s' % [expected_type, *source_location],
      'Instead a %s raised' % type
    ] unless type == expected_type
    nil
  end

  def assert_raised_expected_message message, expected_message, source_location
    regexp = expected_message.is_a?(Regexp) ? expected_message : /\A#{expected_message}\z/
    return [
      'Expected the exception raised at %s:%s' % source_location,
      'to match "%s"' % regexp.source,
      'Instead it looks like',
      message ? message : message.inspect
    ] unless message =~ regexp
    nil
  end
end
