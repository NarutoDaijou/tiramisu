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
  end
end
