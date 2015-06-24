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

    def with *args, &block
      @assert || Kernel.raise(StandardError, '`with` works only with positive assertions')
      args.any? && block && Kernel.raise(ArgumentError, 'both arguments and block given, please use either one')
      return @with = block if block
      @with = if @expected_messages.size > 1
        args.size == @expected_messages.size ||
          Kernel.raise(ArgumentError, "Wrong number of arguments, #{args.size} for #{@expected_messages.size}")
        args.all? {|x| x.is_a?(Array)} ||
          Kernel.raise(ArgumentError, 'Please provide expected arguments as arrays, one array per expected message')
        args
      else
        [args]
      end
      self
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

    def __assert_message_received_with_correct_arguments__ msg, i
      return unless @with
      if @with.is_a?(Proc)
        __received_messages__[msg].find {|(a,_)| @with.call(msg, a)} || Tiramisu.fail([
          'Looks like :%s message never was called with expected arguments' % msg,
          'See validation block'
        ], @caller)
      else
        __received_messages__[msg].find {|(a,_)| a == @with[i]} || Tiramisu.fail([
          'Looks like :%s message never was called with expected arguments:' % msg,
          Tiramisu.pp(@with[i])
        ], @caller)
      end
    end

    def __register_and_send__ m, a, b
      (__received_messages__[m] ||= []).push([a, b])
      @object.__send__(m, *a, &b)
    end
  end
end
