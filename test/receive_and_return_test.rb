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

end
