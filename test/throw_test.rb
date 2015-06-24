describe :throw do

  it 'should pass when any symbol expected and something thrown' do
    this = self
    spec rand do
      test(:test) {assert {throw :x}.throw}
      this.assert_equal :__tiramisu_passed__, run(:test)
    end
  end

  it 'should pass when specific symbol expected and thrown' do
    this = self
    spec rand do
      test(:test) {assert {throw :x}.throw(:x)}
      this.assert_equal :__tiramisu_passed__, run(:test)
    end
  end

  it 'should fail when any throw expected but nothing thrown' do
    this = self
    spec rand do
      test(:test) {assert {}.throw}
      this.assert_equal Tiramisu::GenericFailure, run(:test).class
    end
  end

  it 'should fail when specific symbol expected but nothing thrown' do
    this = self
    spec rand do
      test(:test) {assert {}.throw(:x)}
      this.assert_equal Tiramisu::GenericFailure, run(:test).class
    end
  end

  it 'should pass when correct symbol and value thrown' do
    this = self
    spec rand do
      test(:test) {assert {throw :x, :y}.throw(:x, :y)}
      this.assert_equal :__tiramisu_passed__, run(:test)
    end
  end

  it 'should fail when wrong symbol thrown' do
    this = self
    spec rand do
      test(:test) {assert {throw :y}.throw(:x)}
      this.assert_equal Tiramisu::GenericFailure, run(:test).class
    end
  end

  it 'should fail when wrong value thrown' do
    this = self
    spec rand do
      test(:test) {assert {throw :x, :z}.throw(:x, :y)}
      this.assert_equal Tiramisu::GenericFailure, run(:test).class
    end
  end
end
