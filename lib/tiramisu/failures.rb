module Tiramisu
  module Failures

    Assertion = Struct.new(:object, :arguments, :caller)
    Generic   = Struct.new(:reason, :caller)
    ExpectedMessageNotReceived = Struct.new(:expected_message, :object, :caller)
    UnexpectedMessageReceived = Struct.new(:message, :object, :caller)

  end
end
