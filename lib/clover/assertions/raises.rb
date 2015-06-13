assert :raises do |proc, type, message, &block|

  e = nil
  begin
    proc.call
  rescue Exception => e
  end
  source_location = Clover.relative_source_location(proc)

  e.is_a?(Exception) ||
    fail('Expected a exception to be raised at %s:%s' % source_location)

  if block
    block.call(exception) ||
      fail('Looks like the block at %s:%s did not raise as expected' % source_location)
  end

  if expected_type
    type == expected_type ||
      fail('Expected a %s to be raised at %s:%s' % [
          expected_type,
          *source_location
        ],
        'Instead a %s raised' % type
      )
  end

  if expected_message
    regexp = expected_message.is_a?(Regexp) ? expected_message : /\A#{expected_message}\z/
    message =~ regexp ||
      fail(
        'Expected the exception raised at %s:%s' % source_location,
        'to match "%s"' % regexp.source,
        'Instead it looks like',
        message ? message : message.inspect
      )
  end
end
