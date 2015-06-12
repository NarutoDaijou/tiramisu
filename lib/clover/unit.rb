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

    # run some code before/around/after any or specific tests
    #
    # @example call :define_users before any test (in current spec)
    #   spec User do
    #     before do
    #       @users = ...
    #     end
    #
    #     test :login do
    #       # @users available here
    #     end
    #   end
    #
    # @example run only after :photos test
    #   spec User do
    #     after :photos do
    #       ...
    #     end
    #
    #     test :photos do
    #       ...
    #     end
    #   end
    #
    # @example run around :authorize and :authenticate tests
    #   spec User do
    #     around :authorize, :authenticate do |&test|
    #       SomeApi.with_auth do
    #         test.call # run the test
    #       end
    #     end
    #
    #     test :authorize do
    #       # will run inside `with_auth` block
    #     end
    #
    #     test :authenticate do
    #       # same
    #     end
    #   end
    #
    # @note if multiple hooks defined for same test only the last one will run
    # @note named hooks will have precedence over wildcard ones
    #
    # @example  named hooks have precedence over wildcard ones
    #   before :math do
    #     # named hook, to run only before :math test
    #   end
    #
    #   before do
    #     # wildcard hook, to run before any test
    #   end
    #
    #   test :math do
    #     # only `bofore :math` hook will run here
    #   end
    #
    [
      :before,
      :around,
      :after
    ].each do |hook|
      define_method hook do |*tests,&block|
        block || raise(ArgumentError, 'block missing')
        meth = :"__tiramisu_hooks_#{hook}_#{block.source_location.join}__"
        tests = [:__tiramisu_hooks_any__] if tests.empty?
        tests.each {|t| (hooks[hook] ||= {})[t] = meth}
        define_method(meth, &block)
      end
    end

    def hooks
      @__tiramisu_hooks__ ||= Tiramisu.void_hooks
    end
  end
end
