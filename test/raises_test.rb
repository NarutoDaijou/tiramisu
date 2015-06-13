describe :raises do
  def raisetest type = nil, message = nil, &block
    catch :__clover_status__ do
      assert = Clover::Assert.new(nil, :assert, block)
      if type.is_a?(Proc)
        assert.raises(&type)
      else
        assert.raises(type, message)
      end
    end
  end

  it 'should pass if any exception raised' do
    r = raisetest {x}
    assert_equal true, r
  end

  it 'should fail if nothing raised' do
    r = raisetest {}
    assert r.class == Clover::GenericFailure
    assert r.reason.any? {|l| l =~ /Expected a exception to be raised/}
  end
end
