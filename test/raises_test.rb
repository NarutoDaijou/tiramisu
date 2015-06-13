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

  it 'should pass if type matching' do
    r = raisetest(NameError) {x}
    assert_equal true, r
  end

  it 'should fail if wrong exception raised' do
    r = raisetest(ArgumentError) {x}
    assert r.class == Clover::GenericFailure
    assert r.reason.any? {|l| l =~ /Expected a ArgumentError to be raised/}
  end

  it 'should pass if both type and message matches' do
    r = raisetest(NameError, /undefined local variable or method/) {x}
    assert_equal true, r
  end

  it 'should fail if message does not match' do
    r = raisetest(NameError, /blah/) {x}
    assert r.class == Clover::GenericFailure
    assert r.reason.any? {|l| l =~ /to match/}
  end

  it 'should fail if nothing raised and validation block given' do
    r = raisetest(proc {}) {}
    assert r.class == Clover::GenericFailure
    assert r.reason.any? {|l| l =~ /Expected a exception to be raised/}
  end

  it 'should pass if given block validates exception' do
    r = raisetest(proc {|e| e.class == NameError}) {x}
    assert_equal true, r
  end

  it 'should fail if  given block does not validate exception' do
    p = proc {|e| e.class == ArgumentError}
    r = raisetest(p) {x}
    assert r.class == Clover::GenericFailure
    assert r.reason.any? {|l| l =~ /did not raise as expected/}
  end
end
