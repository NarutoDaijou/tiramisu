describe :raise do
  def assert_raise type = nil, message = nil, &block
    catch :__tiramisu_status__ do
      assert = Tiramisu::Assert.new(nil, :assert, block)
      if type.is_a?(Proc)
        assert.raise(&type)
      else
        assert.raise(type, message)
      end
    end
  end

  it 'should pass if any exception raised' do
    r = assert_raise {x}
    assert_equal true, r
  end

  it 'should fail if nothing raised' do
    r = assert_raise {}
    assert r.class == Tiramisu::GenericFailure
    assert r.reason.any? {|l| l =~ /Expected a exception to be raised/}
  end

  it 'should pass if type matching' do
    r = assert_raise(NameError) {x}
    assert_equal true, r
  end

  it 'should fail if wrong exception raised' do
    r = assert_raise(ArgumentError) {x}
    assert r.class == Tiramisu::GenericFailure
    assert r.reason.any? {|l| l =~ /Expected a ArgumentError to be raised/}
  end

  it 'should pass if both type and message matches' do
    r = assert_raise(NameError, /undefined local variable or method/) {x}
    assert_equal true, r
  end

  it 'should fail if message does not match' do
    r = assert_raise(NameError, /blah/) {x}
    assert r.class == Tiramisu::GenericFailure
    assert r.reason.any? {|l| l =~ /to match/}
  end

  it 'should fail if nothing raised and validation block given' do
    r = assert_raise(proc {}) {}
    assert r.class == Tiramisu::GenericFailure
    assert r.reason.any? {|l| l =~ /Expected a exception to be raised/}
  end

  it 'should pass if given block validates exception' do
    r = assert_raise(proc {|e| e.class == NameError}) {x}
    assert_equal true, r
  end

  it 'should fail if  given block does not validate exception' do
    p = proc {|e| e.class == ArgumentError}
    r = assert_raise(p) {x}
    assert r.class == Tiramisu::GenericFailure
    assert r.reason.any? {|l| l =~ /did not raise as expected/}
  end
end
