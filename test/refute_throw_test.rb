describe :refute_throw do

  it 'should pass when nothing thrown' do
    this = self
    spec rand do
      test(:test) {refute {}.throw}
      this.assert_equal :__tiramisu_passed__, run(:test)
    end
  end

  it 'should fail when something thrown' do
    this = self
    spec rand do
      test(:test) {refute {throw :x}.throw}
      this.assert_equal Tiramisu::GenericFailure, run(:test).class
    end
  end

  it 'should pass when thrown symbol does not match negated one' do
    this = self
    spec rand do
      test(:test) {refute {throw :x}.throw(:y)}
      this.assert_equal :__tiramisu_passed__, run(:test)
    end
  end

  it 'should fail when thrown symbol does match negated one' do
    this = self
    spec rand do
      test(:test) {refute {throw :x}.throw(:x)}
      this.assert_equal Tiramisu::GenericFailure, run(:test).class
    end
  end

  it 'should pass when nor negated symbol nor value matching thrown ones' do
    this = self
    spec rand do
      test(:test) {refute {throw :x, :y}.throw(:a, :b)}
      this.assert_equal :__tiramisu_passed__, run(:test)
    end
  end

  it 'should fail when thrown symbol does match negated one but value does not' do
    this = self
    spec rand do
      test(:test) {refute {throw :x, :z}.throw(:x, :y)}
      this.assert_equal Tiramisu::GenericFailure, run(:test).class
    end
  end

  it 'should fail when a negated symbol given and nothing thrown' do
    this = self
    spec rand do
      test(:test) {refute {}.throw(:x)}
      this.assert_equal Tiramisu::GenericFailure, run(:test).class
    end
  end

  it 'should fail when a negated value given and nothing thrown' do
    this = self
    spec rand do
      test(:test) {refute {}.throw(nil, :y)}
      this.assert_equal Tiramisu::GenericFailure, run(:test).class
    end
  end
end
