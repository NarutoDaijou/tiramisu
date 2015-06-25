module Tiramisu
  class Mock
    def initialize object, expected_messages, assert, caller
      @object = object
      @expected_messages = expected_messages.freeze
      @assert = assert
      @caller = caller
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
      @expected_messages.each_with_index do |msg,i|
        if @assert
          __assert_message_received__(msg)
        else
          return __refute_message_received__(msg)
        end
        __assert_message_received_with_correct_arguments__(msg, i)
      end
    end

    private
    def __assert_message_received__ expected_message
      Tiramisu.fail('Expected %s to receive %s message' % [
        Tiramisu.pp(@object),
        Tiramisu.pp(expected_message)
      ], @caller) unless __received_messages__[expected_message]
    end

    def __refute_message_received__ expected_message
      Tiramisu.fail('Not Expected %s to receive %s message' % [
        Tiramisu.pp(@object),
        Tiramisu.pp(expected_message)
      ], @caller) if __received_messages__[expected_message]
    end

    def __register_and_send__ m, a, b
      (__received_messages__[m] ||= []).push([a, b])
      @object.__send__(m, *a, &b)
    end
  end
end

require 'tiramisu/mock/with'
