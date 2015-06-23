module Tiramisu
  class Mock
    def initialize object, expected_messages, assert = true
      @object, @expected_messages, @assert = object, expected_messages.freeze, assert
    end

    instance_methods.each do |m|
      define_method m do |*a, &b|
        __register_and_send__(m, a, b)
      end
    end

    def method_missing m, *a, &b
      __register_and_send__(m, a, b)
    end

    def __received_messages__
      @__received_messages__ ||= {}
    end

    def __validate__
      @expected_messages.each do |expected_message|
        if @assert
          __assert_message_received__(expected_message)
        else
          __refute_message_received__(expected_message)
        end
      end
    end

    private
    def __assert_message_received__ expected_message
      Kernel.throw(:__tiramisu_status__,
        Failures::ExpectedMessageNotReceived.new(expected_message, @object, @caller)
      ) unless __received_messages__[expected_message]
    end

    def __refute_message_received__ expected_message
      Kernel.throw(:__tiramisu_status__,
        Failures::UnexpectedMessageReceived.new(expected_message, @object, @caller)
      ) if __received_messages__[expected_message]
    end

    def __register_and_send__ m, a, b
      (__received_messages__[m] ||= []).push([a, b])
      @object.__send__(m, *a, &b)
    end
  end
end
