describe :receive_and_raise do

  it 'should pass when received message raises as expected' do
    this = self
    spec rand do
      test :test do
        x = expect(:x).to_receive(:y).and_raise(NoMethodError)
        x.y
      end
      this.assert_equal :__tiramisu_passed__, run(:test)
    end
  end

  it 'should fail when received message does not raise' do
    this = self
    spec rand do
      test :test do
        x = expect(:x).to_receive(:to_s).and_raise
        x.to_s
      end
      this.assert run(:test).reason.any? {|l| l =~ /Expected a exception to be raised/}
    end
  end

  it 'should fail when received message does raises a unexpected error' do
    this = self
    spec rand do
      test :test do
        x = expect(:x).to_receive(:y).and_raise(NameError)
        x.y
      end
      this.assert_match /Expected a NameError to be raised/, run(:test).reason[0]
    end
  end
end
