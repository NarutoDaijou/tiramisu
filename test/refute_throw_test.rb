describe :refute_throw do
  def refute_throw *args, &block
    catch :__tiramisu_status__ do
      Tiramisu::Assert.new(nil, :refute, block).throw(*args)
    end
  end

  it 'should pass when nothing thrown' do
    r = refute_throw {}
    assert_equal true, r
  end

end
