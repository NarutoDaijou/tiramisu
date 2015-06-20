describe :raises do
  def raisetest type = nil, message = nil, &block
    catch :__tiramisu_status__ do
      assert = Tiramisu::Assert.new(nil, :refute, block)
      if type.is_a?(Proc)
        assert.raise(&type)
      else
        assert.raise(type, message)
      end
    end
  end

  it 'should pass if no exception expected and no exception raised' do
    r = raisetest {}
    assert_equal true, r
  end

  it 'should fail if exception raised when not expected' do
    r = raisetest {x}
    assert r.class == Tiramisu::Failures::Generic
    assert r.reason.any? {|l| l =~ /unexpected NameError raised/}
  end
end
