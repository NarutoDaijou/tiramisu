module Tiramisu
  class Mock
    class Expectation

      attr_reader :received_messages

      def initialize expected_messages, assert, caller
        @expected_messages = expected_messages
        @assert = assert
        @caller = caller
      end

      def validate received_messages
        @received_messages = received_messages
        @expected_messages.each_with_index do |msg,i|
          return refute_message_received(msg) unless @assert
          assert_message_received(msg)
          assert_message_received_with_correct_arguments(msg, i)
          assert_message_returned_correct_value(msg, i)
          assert_message_raised_as_expected(msg, i)
          assert_message_thrown_as_expected(msg, i)
        end
      end

      private
      def assert_message_received expected_message
        Tiramisu.fail('Expected %s to receive %s message' % [
          Tiramisu.pp(@object),
          Tiramisu.pp(expected_message)
        ], @caller) unless received_messages[expected_message]
      end

      def refute_message_received expected_message
        Tiramisu.fail('Not Expected %s to receive %s message' % [
          Tiramisu.pp(@object),
          Tiramisu.pp(expected_message)
        ], @caller) if received_messages[expected_message]
      end
    end
  end
end

require 'tiramisu/mock/expectation/with'
require 'tiramisu/mock/expectation/return'
require 'tiramisu/mock/expectation/raise'
require 'tiramisu/mock/expectation/throw'
