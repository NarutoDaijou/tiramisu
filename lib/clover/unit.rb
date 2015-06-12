module Clover
  class Unit

  end

  class << Unit

    def spec
      raise(NotImplementedError, 'Nested specs not supported. Please use a context instead')
    end

    # define a context inside current spec/context.
    #
    # @param label
    # @param &block
    def context label, &block
      return unless block
      Clover.define_and_register_a_context(label, block, self)
    end

    # define a test
    #
    # @param label
    # @param &block
    def test label, &block
      return unless block
      tests[label] = Clover.identity_string(:test, label, block)
      define_method(tests[label], &block)
    end
    alias it test

    def tests
      @__tiramisu_tests__ ||= {}
    end
  end
end
