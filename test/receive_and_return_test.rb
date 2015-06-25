describe :receive_and_return do

  it 'should pass when expected message returns expected value' do
    this = self
    spec rand do
      test :test do
        mock = expect(1).to_receive(:+).with(1).and_return(2)
        mock + 1
      end
      this.assert_equal :__tiramisu_passed__, run(:test)
    end
  end

  it 'should fail when expected message returns wrong value' do
    this = self
    spec rand do
      test :test do
        mock = expect(:x).to_receive(:to_s).and_return(:y)
        mock.to_s
      end
      this.assert run(:test).reason.any? {|l| l =~ /Looks like :to_s message never returned expected value/}
    end
  end

  it 'should pass when block validates returned value' do
    this = self
    spec rand do
      test :test do
        mock = expect(1).to_receive(:+).with(1).and_return {|_,v| v == 2}
        mock + 1
      end
      this.assert_equal :__tiramisu_passed__, run(:test)
    end
  end

  it 'should fail when block does not validate returned value' do
    this = self
    spec rand do
      test :test do
        mock = expect(1).to_receive(:+).with(1).and_return {false}
        mock + 1
      end
      this.assert run(:test).reason.any? {|l| l =~ /Looks like :\+ message never returned expected value/}
    end
  end

  it 'should pass when all messages returned expected value' do
    this = self
    spec rand do
      test :test do
        mock = expect(1).to_receive(:+, :-).with([1], [1]).and_return(2, 0)
        mock + 1
        mock - 1
      end
      this.assert_equal :__tiramisu_passed__, run(:test)
    end
  end

  it 'should fail when at least one message returns wrong value' do
    this = self
    spec rand do
      test :test do
        mock = expect(1).to_receive(:+, :-).with([1], [1]).and_return(2, 2)
        mock + 1
        mock - 1
      end
      this.assert run(:test).reason.any? {|l| l =~ /Looks like :\- message never returned expected value/}
    end
  end
end
