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
end
