module Tiramisu
  module Failures

    Generic = Struct.new(:reason, :caller)
    Assertion = Struct.new(:object, :arguments, :caller)
    ExpectedMessageNotReceived = Struct.new(:expected_message, :object, :caller)
    UnexpectedMessageReceived = Struct.new(:message, :object, :caller)

  end
end
