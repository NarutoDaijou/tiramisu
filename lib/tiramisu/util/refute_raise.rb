module Tiramisu

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

    f = refute_raised(e, source_location, expected_type || expected_message || block)
    return f if f

    if block
      f = refute_raised_as_expected_by_block(e, block, source_location)
      return f if f
    end

    if expected_type
      type_failed = refute_raised_expected_type(e.class, expected_type, source_location)
      if expected_message
        message_failed = refute_raised_expected_message(e.message, expected_message, source_location)
        return if type_failed && message_failed
        return    type_failed || message_failed
      end
      return type_failed if type_failed
    end

    if expected_message
      f = refute_raised_expected_message(e.message, expected_message, source_location)
      return f if f
    end
    nil
  end

  def refute_raised x, source_location, should_raise = false
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
    nil
  end

  def refute_raised_as_expected_by_block exception, block, source_location
    return [
      'Looks like a unexpected exception raised at %s:%s' % source_location,
      'Check validation block'
    ] if block.call(exception)
    nil
  end

  def refute_raised_expected_type type, expected_type, source_location
    return [
      'Not expected raised exception to be of type %s' % type,
      'at %s:%s' % source_location
    ] if type == expected_type
    nil
  end

  def refute_raised_expected_message message, expected_message, source_location
    regexp = expected_message.is_a?(Regexp) ? expected_message : /\A#{expected_message}\z/
    return [
      'Not expected raised exception to match %s' % regexp.inspect,
      '"%s" at %s:%s' % [message, *source_location]
    ] if message =~ regexp
    nil
  end
end
