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
end
