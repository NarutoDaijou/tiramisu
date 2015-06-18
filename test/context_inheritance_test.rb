describe :context_inheritance_test do

  it 'inherits from parent spec' do
    x = nil
    spec rand do
      define_method(:set_x) {x = true}
      context rand do
        allocate.send(:set_x)
      end
    end
    assert_equal true, x
  end

  it 'inherits from parent context' do
    x = nil
    spec rand do
      context rand do
        define_method(:set_x) {x = true}
        context rand do
          allocate.send(:set_x)
        end
      end
    end
    assert_equal true, x
  end

  it 'inherits from parent spec through parent context' do
    x = nil
    spec rand do
      define_method(:set_x) {x = true}
      context rand do
        context rand do
          allocate.send(:set_x)
        end
      end
    end
    assert_equal true, x
  end

  it 'does not inherit tests' do
    spec_tests, context_tests = nil
    spec rand do
      test(:x) {}
      context rand do
        context_tests = tests.size
      end
      spec_tests = tests.size
    end
    assert_equal 1, spec_tests
    assert_equal 0, context_tests
  end

  it 'does not inherit hooks' do
    spec_hooks, context_hooks = nil
    spec rand do
      before {}
      context rand do
        context_hooks = hooks[:before].size
      end
      spec_hooks = hooks[:before].size
    end
    assert_equal 1, spec_hooks
    assert_equal 0, context_hooks
  end
end
