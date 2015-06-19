module Tiramisu
  class Mock
    def initialize object
      @object = object
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

    private
    def __register_and_send__ m, a, b
      (__received_messages__[m] ||= []).push([a, b])
      @object.__send__(m, *a, &b)
    end
  end
end
