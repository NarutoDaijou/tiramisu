describe :raise do

  it 'should pass if any exception raised' do
    this = self
    spec rand do
      test(:test) {assert {x}.raise}
      this.assert_equal :__tiramisu_passed__, run(:test)
    end
  end

  it 'should fail if nothing raised' do
    this = self
    spec rand do
      test(:test) {assert {}.raise}
      this.assert_equal Tiramisu::GenericFailure, run(:test).class
    end
  end

  it 'should pass if type matching' do
    this = self
    spec rand do
      test(:test) {assert {x}.raise(NameError)}
      this.assert_equal :__tiramisu_passed__, run(:test)
    end
  end

  it 'should fail if wrong exception raised' do
    this = self
    spec rand do
      test(:test) {assert {}.raise(ArgumentError)}
      this.assert_equal Tiramisu::GenericFailure, run(:test).class
    end
  end

  it 'should pass if both type and message matches' do
    this = self
    spec rand do
      test(:test) {assert {x}.raise NameError, /undefined local variable or method/}
      this.assert_equal :__tiramisu_passed__, run(:test)
    end
  end

  it 'should fail if message does not match' do
    this = self
    spec rand do
      test(:test) {assert {x}.raise(NameError, /blah/)}
      this.assert_equal Tiramisu::GenericFailure, run(:test).class
    end
  end

  it 'should fail if nothing raised and validation block given' do
    this = self
    spec rand do
      test(:test) {assert {}.raise {}}
      this.assert_equal Tiramisu::GenericFailure, run(:test).class
    end
  end

  it 'should pass if given block validates exception' do
    this = self
    spec rand do
      test(:test) {assert {x}.raise {|e| e.is_a?(NameError)}}
      this.assert_equal :__tiramisu_passed__, run(:test)
    end
  end

  it 'should fail if  given block does not validate exception' do
    this = self
    spec rand do
      test(:test) {assert {x}.raise {false}}
      this.assert_equal Tiramisu::GenericFailure, run(:test).class
    end
  end
end
