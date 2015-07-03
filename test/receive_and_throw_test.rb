describe :receive_and_throw do

  it 'should pass when received message throws whatever' do
    this = self
    spec rand do
      test :test do
        x = mock(Class.new {define_singleton_method(:y) {throw :z}})
        expect(x).to_receive(:y).and_throw
        x.y
      end
      this.assert_equal :__tiramisu_passed__, run(:test)
    end
  end

  it 'should pass when received message throws expected symbol' do
    this = self
    spec rand do
      test :test do
        x = mock(Class.new {define_singleton_method(:y) {throw :z}})
        expect(x).to_receive(:y).and_throw(:z)
        x.y
      end
      this.assert_equal :__tiramisu_passed__, run(:test)
    end
  end

  it 'should fail when received message throws nothing' do
    this = self
    spec rand do
      test :test do
        x = mock(Class.new {define_singleton_method(:y) {}})
        expect(x).to_receive(:y).and_throw
        x.y
      end
      this.assert_match /Expected a symbol to be thrown/, run(:test).reason*' '
    end
  end

  it 'should fail when received message throws wrong symbol' do
    this = self
    spec rand do
      test :test do
        x = mock(Class.new {define_singleton_method(:y) {throw :z}})
        expect(x).to_receive(:y).and_throw(:a)
        x.y
      end
      this.assert_match /Expected :a to be thrown/, run(:test).reason*' '
    end
  end

  it 'should pass when all received messages throws as expected' do
    this = self
    spec rand do
      test :test do
        x = mock(Class.new {
          define_singleton_method(:a) {throw :A}
          define_singleton_method(:b) {throw :B}
        })
        expect(x).to_receive(:a, :b).and_throw(:A, :B)
        x.a
        x.b
      end
      this.assert_equal :__tiramisu_passed__, run(:test)
    end
  end

  it 'should fail when at least one message throws wrong symbol' do
    this = self
    spec rand do
      test :test do
        x = mock(Class.new {
          define_singleton_method(:a) {throw :X}
          define_singleton_method(:b) {throw :B}
        })
        expect(x).to_receive(:a, :b).and_throw(:A, :B)
        x.a
        x.b
      end
      this.assert_match /Expected :A to be thrown.+Instead :X thrown/, run(:test).reason*' '
    end
  end


  it 'should fail when at least one message throws nothing' do
    this = self
    spec rand do
      test :test do
        x = mock(Class.new {
          define_singleton_method(:a) {throw :A}
          define_singleton_method(:b) {}
        })
        expect(x).to_receive(:a, :b).and_throw(:A, :B)
        x.a
        x.b
      end
      this.assert_match /Expected a symbol to be thrown/, run(:test).reason*' '
    end
  end
end
