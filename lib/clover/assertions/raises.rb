assert :raises do |proc, type, message, &block|
  Clover.raised_as_expected?(proc, type, message, block)
  true # if arriving here without failing the assertion is passed
end

module Clover
  def raised_as_expected? proc, expected_type, expected_message, block
    e = nil
    begin
      proc.call
    rescue Exception => e
    end
    source_location = Clover.relative_source_location(proc)
    raised?(e, source_location)
    return raised_as_expected_by_block?(e, block, source_location) if block
    if expected_type
      raised_expected_type?(e.class, expected_type, source_location)
    end
    if expected_message
      raised_expected_message?(e.message, expected_message, source_location)
    end
  end

  def raised? x, source_location
    return if x.is_a?(Exception)
    fail('Expected a exception to be raised at %s:%s' % source_location)
  end

  def raised_expected_type? type, expected_type, source_location
  end

  def raised_expected_message? message, expected_message, source_location
  end

  def raised_as_expected_by_block? exception, block, source_location
  end
end
