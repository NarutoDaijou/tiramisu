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

end
