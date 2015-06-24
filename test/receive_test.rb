describe :receive do

  it 'should pass when a message expected and received' do
    this = self
    spec rand do
      test :test do
        mock = expect(:x).to_receive(:class)
        mock.class
      end
      this.assert_equal :__tiramisu_passed__, run(:test)
    end
  end

  it 'should fail when a expected message not received' do
    this = self
    spec rand do
      test :test do
        mock = expect(:x).to_receive(:class)
      end
      this.assert run(:test).is_a?(Tiramisu::Failures::Generic)
    end
  end

  it 'should pass when no message expected and no message received' do
    this = self
    spec rand do
      test :test do
        mock = fail_if(:x).receive(:class)
      end
      this.assert_equal :__tiramisu_passed__, run(:test)
    end
  end

  it 'should fail when unexpected message received' do
    this = self
    spec rand do
      test :test do
        mock = fail_if(:x).receive(:class)
        mock.class
      end
      this.assert run(:test).is_a?(Tiramisu::Failures::Generic)
    end
  end
end
