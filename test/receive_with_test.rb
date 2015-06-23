describe :receive_with do

  it 'should pass when called with correct arguments' do
    this = self
    spec rand do
      test :test do
        mock = expect(1).to_receive(:+).with(1)
        mock + 1
      end
      this.assert_equal :__tiramisu_passed__, run(:test)
    end
  end
end
