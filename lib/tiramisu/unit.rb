module Tiramisu
  class Unit
    # @example
    #   assert(x) == y
    #   assert(x).include?(y)
    #   assert(x).nil?
    #   refute(a).include?(b)
    #   fail_if(a).include?(b)
    [
      :assert,
      :refute
    ].each do |meth|
      define_method meth do |obj = nil, &block|
        __assertions__.push(Tiramisu::Assert.new(obj, meth, block, caller[0])).last
      end
    end
    alias expect assert
    alias fail_if refute

    # stop executing current test and mark it as skipped
    #
    # @example
    #   test :something do
    #     skip "recheck this after fixing X"
    #     assert(x) == y # this wont run
    #   end
    #
    def skip reason = nil
      throw(:__tiramisu_status__, Tiramisu::Skip.new(reason, caller[0]))
    end

    def __run__ test, before, around, after
      __send__(before) if before
      if around
        __send__(around) {__send__(test)}
      else
        __send__(test)
      end
      __send__(after) if after
      __assertions__.each(&:__validate_expected_messages__)
      :__tiramisu_passed__
    rescue Exception => e
      throw(:__tiramisu_status__, e)
    end

    def __assertions__
      @__assertions__ ||= []
    end
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
      Tiramisu.define_and_register_a_context(label, block, self)
    end

    # define a test
    #
    # @param label
    # @param &block
    def test label, &block
      return unless block
      tests[label] = Tiramisu.identity_string(:test, label, block)
      define_method(tests[label], &block)
    end
    alias it test
    alias should test

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

    # skipping a whole spec/context
    #
    # @example
    #   spec Array do
    #     skip
    #
    #     # code here wont be executed
    #   end
    def skip reason = nil
      throw(:__tiramisu_skip__, Tiramisu::Skip.new(reason, caller[0]))
    end

    def run test
      tests[test] || raise(StandardError, 'Undefined test %s at "%s"' % [test.inspect, __identity__])
      catch :__tiramisu_status__ do
        allocate.__run__ tests[test],
          hooks[:before][test] || hooks[:before][:__tiramisu_hooks_any__],
          hooks[:around][test] || hooks[:around][:__tiramisu_hooks_any__],
          hooks[:after][test]  || hooks[:after][:__tiramisu_hooks_any__]
      end
    end
  end
end
