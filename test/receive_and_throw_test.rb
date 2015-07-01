describe :receive_and_throw do

  it 'should pass when received message throws whatever' do
    this = self
    spec rand do
      test :test do
        x = expect(Class.new {define_singleton_method(:y) {throw :z}}).to_receive(:y).and_throw
        x.y
      end
      this.assert_equal :__tiramisu_passed__, run(:test)
    end
  end

  it 'should pass when received message throws expected symbol' do
    this = self
    spec rand do
      test :test do
        x = expect(Class.new {define_singleton_method(:y) {throw :z}}).to_receive(:y).and_throw(:z)
        x.y
      end
      this.assert_equal :__tiramisu_passed__, run(:test)
    end
  end

  it 'should fail when received message throws nothing' do
    this = self
    spec rand do
      test :test do
        x = expect(Class.new {define_singleton_method(:y) {}}).to_receive(:y).and_throw
        x.y
      end
      this.assert_match /Expected a symbol to be thrown/, run(:test).reason[0]
    end
  end

  it 'should fail when received message throws wrong symbol' do
    this = self
    spec rand do
      test :test do
        x = expect(Class.new {define_singleton_method(:y) {throw :z}}).to_receive(:y).and_throw(:a)
        x.y
      end
      this.assert_match /Expected :a to be thrown/, run(:test).reason[0]
    end
  end

  it 'should pass when received message throws expected symbol and value' do
    this = self
    spec rand do
      test :test do
        x = expect(Class.new {define_singleton_method(:y) {throw :a, :b}}).to_receive(:y).and_throw(:a, :b)
        x.y
      end
      this.assert_equal :__tiramisu_passed__, run(:test)
    end
  end

  it 'should fail when received message throws correct symbol but wrong value' do
    this = self
    spec rand do
      test :test do
        x = expect(Class.new {define_singleton_method(:y) {throw :a, :b}}).to_receive(:y).and_throw(:a, :z)
        x.y
      end
      this.assert_match /Wrong value thrown/, run(:test).reason[0]
    end
  end
end
