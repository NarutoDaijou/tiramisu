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

  # call the given block and check whether it raised any exception.
  # if everything raised as expected return nil,
  # otherwise return a failure
  def refute_raised_as_expected proc, expected_type, expected_message, block
    e = nil
    begin
      proc.call
    rescue Exception => e
    end
    source_location = Tiramisu.relative_source_location(proc)

    f = raised_anything?(e, source_location, negate, expected_type || expected_message || block)
    return f if f

    if block
      f = raised_as_expected_by_block?(e, block, source_location, negate)
      return f if f
    end

    if expected_type
      type_failed = raised_expected_type?(e.class, expected_type, source_location, negate)
      if negate && expected_message
        message_failed = raised_expected_message?(e.message, expected_message, source_location, negate)
        return if type_failed && message_failed
        return    type_failed || message_failed
      else
        return type_failed if type_failed
      end
    end

    if expected_message
      f = raised_expected_message?(e.message, expected_message, source_location, negate)
      return f if f
    end
    nil
  end



  def refute_raised x, source_location
    if negate
      if should_raise
        return [
          'Expected a exception to be raised at %s:%s' % source_location
        ] unless x.is_a?(Exception)
      else
        return 'A unexpected %s raised at %s:%s' % [
          x.class.name,
          *source_location
        ] if x.is_a?(Exception)
      end
    else
    end
    return [
      'Expected a exception to be raised at %s:%s' % source_location
    ] unless x.is_a?(Exception)
    nil
  end

  def raised_as_expected_by_block? exception, block, source_location, negate
    if negate
      return [
        'Looks like a unexpected exception raised at %s:%s' % source_location,
        'Check validation block'
      ] if block.call(exception)
    else
      return [
        'Looks like the block at %s:%s did not raise as expected' % source_location,
        'Check validation block'
      ] unless block.call(exception)
    end
    nil
  end

  def raised_expected_type? type, expected_type, source_location, negate
    if negate
      return [
        'Not expected raised exception to be of type %s' % type,
        'at %s:%s' % source_location
      ] if type == expected_type
    else
      return [
        'Expected a %s to be raised at %s:%s' % [expected_type, *source_location],
        'Instead a %s raised' % type
      ] unless type == expected_type
    end
    nil
  end

  def raised_expected_message? message, expected_message, source_location, negate
    regexp = expected_message.is_a?(Regexp) ? expected_message : /\A#{expected_message}\z/
    if negate
      return [
        'Not expected raised exception to match %s' % regexp.inspect,
        '"%s" at %s:%s' % [message, *source_location]
      ] if message =~ regexp
    else
      return [
        'Expected the exception raised at %s:%s' % source_location,
        'to match "%s"' % regexp.source,
        'Instead it looks like',
        message ? message : message.inspect
      ] unless message =~ regexp
    end
    nil
  end
end
