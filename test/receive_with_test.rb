describe :receive_with do

  it 'should pass when called with correct arguments' do
    this = self
    spec rand do
      test :test do
        x = mock(1)
        expect(x).to_receive(:+).with(1)
        x + 1
      end
      this.assert_equal :__tiramisu_passed__, run(:test)
    end
  end

  it 'should fail when called without arguments' do
    this = self
    spec rand do
      test :test do
        x = mock([])
        expect(x).to_receive(:join).with('')
        x.join
      end
      this.assert_match /Looks like :join message never was called with expected arguments/, run(:test).reason*' '
    end
  end

  it 'should fail when called with wrong arguments' do
    this = self
    spec rand do
      test :test do
        x = mock([])
        expect(x).to_receive(:join).with('')
        x.join('/')
      end
      this.assert_match /Looks like :join message never was called with expected arguments/, run(:test).reason*' '
    end
  end

  it 'should pass when block validates arguments' do
    this = self
    spec rand do
      test :test do
        x = mock(1)
        expect(x).to_receive(:+).with {|_,a| a == [1]}
        x + 1
      end
      this.assert_equal :__tiramisu_passed__, run(:test)
    end
  end

  it 'should fail when block does not validate arguments' do
    this = self
    spec rand do
      test :test do
        x = mock(1)
        expect(x).to_receive(:+).with {false}
        x + 1
      end
      this.assert_match /Looks like :\+ message never was called with expected arguments/, run(:test).reason*' '
    end
  end

  it 'should pass when all expected messages received with expected arguments' do
    this = self
    spec rand do
      test :test do
        x = mock([])
        expect(x).to_receive(:include?, :concat).with([1], [[1]])
        x.include? 1
        x.concat [1]
      end
      this.assert_equal :__tiramisu_passed__, run(:test)
    end
  end

  it 'should fail when at least one message received with wrong arguments' do
    this = self
    spec rand do
      test :test do
        x = mock([])
        expect(x).to_receive(:include?, :concat).with([1], [[1]])
        x.include? 1
        x.concat [2]
      end
      this.assert_match /Looks like :concat message never was called with expected arguments/, run(:test).reason*' '
    end
  end

  it 'should pass when block validates arguments for all received messages' do
    this = self
    spec rand do
      test :test do
        x = mock(1)
        expect(x).to_receive(:+, :-).with {|m,a| {:+ => [1], :- => [2]}[m] == a}
        x + 1
        x - 2
      end
      this.assert_equal :__tiramisu_passed__, run(:test)
    end
  end

  it 'should fail when block does validate arguments for some of received messages' do
    this = self
    spec rand do
      test :test do
        x = mock(1)
        expect(x).to_receive(:+, :-).with {false}
        x + 1
        x - 2
      end
      this.assert_match /Looks like :\+ message never was called with expected arguments/, run(:test).reason*' '
    end
  end
end
