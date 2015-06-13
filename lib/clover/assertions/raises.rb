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

  if type
    type == type ||
      fail('Expected a %s to be raised at %s:%s' % [
          type,
          *source_location
        ],
        'Instead a %s raised' % type
      )
  end

  if message
    regexp = message.is_a?(Regexp) ? message : /\A#{message}\z/
    message =~ regexp ||
      fail(
        'Expected the exception raised at %s:%s' % source_location,
        'to match "%s"' % regexp.source,
        'Instead it looks like',
        message ? message : message.inspect
      )
  end
  true
end
