describe :refute_raise do

  it 'should pass if no exception expected and no exception raised' do
    this = self
    spec rand do
      test(:test) {refute {}.raise}
      this.assert_equal :__tiramisu_passed__, run(:test)
    end
  end

  it 'should fail if exception raised when not expected' do
    this = self
    spec rand do
      test(:test) {refute {x}.raise}
      this.assert_equal Tiramisu::GenericFailure, run(:test).class
    end
  end

  it 'should fail if exception of specific type negated but nothing raised' do
    this = self
    spec rand do
      test(:test) {refute {}.raise NameError}
      this.assert_equal Tiramisu::GenericFailure, run(:test).class
    end
  end

  it 'should fail if exception with specific message negated but nothing raised' do
    this = self
    spec rand do
      test(:test) {refute {}.raise nil, /blah/}
      this.assert_equal Tiramisu::GenericFailure, run(:test).class
    end
  end

  it 'should fail if a validation block provided but nothing raised' do
    this = self
    spec rand do
      test(:test) {refute {}.raise {}}
      this.assert_equal Tiramisu::GenericFailure, run(:test).class
    end
  end

  it 'should pass if it raises a exception type different from negated one' do
    this = self
    spec rand do
      test(:test) {refute {x}.raise(ArgumentError)}
      this.assert_equal :__tiramisu_passed__, run(:test)
    end
  end

  it 'should fail if it raises a exception of same type as negated one' do
    this = self
    spec rand do
      test(:test) {refute {x}.raise NameError}
      this.assert_equal Tiramisu::GenericFailure, run(:test).class
    end
  end

  it 'should pass if it raises a exception with a message different from negated one' do
    this = self
    spec rand do
      test(:test) {refute {x}.raise nil, /blah/}
      this.assert_equal :__tiramisu_passed__, run(:test)
    end
  end

  it 'should fail if it raises a exception with a message matching negated one' do
    this = self
    spec rand do
      test(:test) {refute {x}.raise nil, /undefined local variable/}
      this.assert_equal Tiramisu::GenericFailure, run(:test).class
    end
  end

  it 'should pass if raised type is not of negated type and error message does not match negated message' do
    this = self
    spec rand do
      test(:test) {refute {x}.raise ArgumentError, /blah/}
      this.assert_equal :__tiramisu_passed__, run(:test)
    end
  end

  it 'should fail if raised type is of negated type' do
    this = self
    spec rand do
      test(:test) {refute {x}.raise NameError, /blah/}
      this.assert_equal Tiramisu::GenericFailure, run(:test).class
    end
  end

  it 'should fail if error message matches negated one' do
    this = self
    spec rand do
      test(:test) {refute {x}.raise ArgumentError, /undefined local variable/}
      this.assert_equal Tiramisu::GenericFailure, run(:test).class
    end
  end
end
