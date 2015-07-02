module Tiramisu
  class Mock

    def initialize object, caller
      @object = object
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

    def __expected_messages__
      @expected_messages ||= []
    end

    def __unexpected_messages__
      @unexpected_messages ||= []
    end

    def __received_messages__
      @__received_messages__ ||= {}
    end

    def __validate__
      __unexpected_messages__.each do |msgs|
        msgs.each {|msg| __refute_message_received__(msg)}
      end
      __expected_messages__.each do |msgs|
        msgs.each_with_index do |msg,i|
          __assert_message_received__(msg)
          __assert_message_received_with_correct_arguments__(msg, i)
          __assert_message_returned_correct_value__(msg, i)
          __assert_message_raised_as_expected__(msg, i)
          __assert_message_thrown_as_expected__(msg, i)
        end
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
      log = {arguments: a, block: b}
      (__received_messages__[m] ||= []).push(log)
      if @throw
        expected_symbol = Array(@throw[@expected_messages.find_index {|x| x == m}]).first
        return log[:thrown] = Tiramisu.catch_symbol(Kernel.proc {@object.__send__(m, *a, &b)}, expected_symbol)
      end
      begin
        log[:returned] = @object.__send__(m, *a, &b)
      rescue Exception => e
        log[:raised] = e
      end
    end
  end
end

require 'tiramisu/mock/with'
require 'tiramisu/mock/return'
require 'tiramisu/mock/raise'
require 'tiramisu/mock/throw'
