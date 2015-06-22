module Tiramisu

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
