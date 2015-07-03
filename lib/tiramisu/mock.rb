module Tiramisu
  class Mock

    def initialize object
      @object = object
    end

    instance_methods.each do |m|
      define_method m do |*a, &b|
        __tiramisu__register_and_send__(m, a, b)
      end
    end

    def method_missing m, *a, &b
      __tiramisu__register_and_send__(m, a, b)
    end

    def __tiramisu__expectations__
      @__tiramisu__expectations__ ||= []
    end

    def __tiramisu__messages__
      @__tiramisu__messages__ ||= {}
    end

    def __tiramisu__validate_messages__
      __tiramisu__messages__.freeze
      __tiramisu__expectations__.each do |expectation|
        expectation.validate(__tiramisu__messages__)
      end
    end

    private
    def __tiramisu__register_and_send__ m, a, b
      log = {arguments: a, block: b}
      (__tiramisu__messages__[m] ||= []).push(log)
      begin
        log[:returned] = @object.__send__(m, *a, &b)
      rescue UncaughtThrowError => e
        log[:thrown] = Tiramisu.extract_thrown_symbol(e)
      rescue Exception => e
        log[:raised] = e
      end
    end
  end
end

require 'tiramisu/mock/expectation'
