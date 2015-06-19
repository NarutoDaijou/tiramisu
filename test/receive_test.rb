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
  end

  it 'should pass when no message expected and no message received' do
  end

  it 'should fail when unexpected message received' do
  end
end