describe :throws do
  def throwstest *args, &block
    catch :__tiramisu_status__ do
      Tiramisu::Assert.new(nil, :assert, block).throws(*args)
    end
  end

  it 'should pass when correct symbol thrown' do
    r = throwstest(:x) {throw :x}
    assert_equal true, r
  end
end
