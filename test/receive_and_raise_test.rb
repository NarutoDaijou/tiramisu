describe :receive_and_raise do

  it 'should pass when received message raises as expected' do
    this = self
    spec rand do
      test :test do
        x = mock(:x)
        expect(x).to_receive(:y).and_raise(NoMethodError)
        x.y
      end
      this.assert_equal :__tiramisu_passed__, run(:test)
    end
  end

  it 'should pass when received message raises whatever error' do
    this = self
    spec rand do
      test :test do
        x = mock(:x)
        expect(x).to_receive(:y).and_raise
        x.y
      end
      this.assert_equal :__tiramisu_passed__, run(:test)
    end
  end

  it 'should fail when received message does not raise' do
    this = self
    spec rand do
      test :test do
        x = mock(:x)
        expect(x).to_receive(:to_s).and_raise
        x.to_s
      end
      this.assert_match /Expected a exception to be raised/, run(:test).reason*' '
    end
  end

  it 'should fail when received message raises a unexpected error type' do
    this = self
    spec rand do
      test :test do
        x = mock(:x)
        expect(x).to_receive(:y).and_raise(NameError)
        x.y
      end
      this.assert_match /Expected a NameError to be raised/, run(:test).reason*' '
    end
  end

  it 'should fail when error raised by received message is of expected type but error message does not match' do
    this = self
    spec rand do
      test :test do
        x = mock(:x)
        expect(x).to_receive(:y).and_raise(NoMethodError, /blah/)
        x.y
      end
      this.assert_match /to match "blah"/, run(:test).reason*' '
    end
  end

  it 'should pass if received message raises a error that match by type and message' do
    this = self
    spec rand do
      test :test do
        x = mock(:x)
        expect(x).to_receive(:y).and_raise(NoMethodError, /undefined method `y' for :x:Symbol/)
        x.y
      end
      this.assert_equal :__tiramisu_passed__, run(:test)
    end
  end

  it 'should pass if error raised by received message are validated by block' do
    this, t, m = self, nil, nil
    spec rand do
      test :test do
        x = mock(:x)
        expect(x).to_receive(:y).and_raise {|_,e|
          t, m = e.class, e.message
          this.assert_match /undefined method .y. for :x:Symbol/, e.message
        }
        x.y
      end
      run(:test)
      this.assert_equal NoMethodError, t
      this.assert_match /undefined method .y. for :x:Symbol/, m
    end
  end

  it 'should pass if all received messages raised as expected' do
    this = self
    spec rand do
      test :test do
        x = mock([])
        expect(x).to_receive(:y, :include?).and_raise(NoMethodError, ArgumentError)
        x.y
        x.include?
      end
      this.assert_equal :__tiramisu_passed__, run(:test)
    end
  end

  it 'should fail if at least one message does not raise as expected' do
    this = self
    spec rand do
      test :test do
        x = mock([])
        expect(x).to_receive(:y, :include?).and_raise(NoMethodError, NameError)
        x.y
        x.include?
      end
      this.assert_match /Expected a NameError to be raised/, run(:test).reason*' '
    end
  end
end
