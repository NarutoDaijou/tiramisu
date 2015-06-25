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
      this.assert_equal Tiramisu::GenericFailure, run(:test).class
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
      this.assert_equal Tiramisu::GenericFailure, run(:test).class
    end
  end

  it 'should pass when all of expected messages received' do
    this = self
    spec rand do
      test :test do
        mock = expect(:x).to_receive(:to_s, :inspect)
        mock.to_s
        mock.inspect
      end
      this.assert_equal :__tiramisu_passed__, run(:test)
    end
  end

  it 'should fail when at least one of expected messages not received' do
    this = self
    spec rand do
      test :test do
        mock = expect(:x).to_receive(:to_s, :inspect)
        mock.inspect
      end
      this.assert_equal Tiramisu::GenericFailure, run(:test).class
    end
  end
end
