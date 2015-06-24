describe :refute_raise do
  def refute_raise type = nil, message = nil, &block
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
    r = refute_raise {}
    assert_equal true, r
  end

  it 'should fail if exception raised when not expected' do
    r = refute_raise {x}
    assert r.class == Tiramisu::GenericFailure
    assert r.reason.any? {|l| l =~ /A unexpected exception raised/}
  end

  it 'should fail if exception of specific type negated but nothing raised' do
    r = refute_raise(NameError) {}
    assert r.class == Tiramisu::GenericFailure
    assert r.reason.any? {|l| l =~ /Expected a exception to be raised/}
  end

  it 'should fail if exception with specific message negated but nothing raised' do
    r = refute_raise(nil, 'x') {}
    assert r.class == Tiramisu::GenericFailure
    assert r.reason.any? {|l| l =~ /Expected a exception to be raised/}
  end

  it 'should fail if a validation block provided but nothing raised' do
    r = refute_raise(proc {}) {}
    assert r.class == Tiramisu::GenericFailure
    assert r.reason.any? {|l| l =~ /Expected a exception to be raised/}
  end

  it 'should pass if it raises a exception type different from negated one' do
    r = refute_raise(ArgumentError) {x}
    assert_equal true, r
  end

  it 'should fail if it raises a exception of same type as negated one' do
    r = refute_raise(NameError) {x}
    assert r.class == Tiramisu::GenericFailure
    assert r.reason.any? {|l| l =~ /Not expected a NameError to be raised/}
  end

  it 'should pass if it raises a exception with a message different from negated one' do
    r = refute_raise(nil, 'blah') {x}
    assert_equal true, r
  end

  it 'should fail if it raises a exception with a message matching negated one' do
    r = refute_raise(nil, /undefined local variable or method/) {x}
    assert r.class == Tiramisu::GenericFailure
    assert r.reason.any? {|l| l =~ /Not expected raised exception to match \/undefined/}
  end

  it 'should pass if raised type is not of negated type and error message does not match negated message' do
    r = refute_raise(ArgumentError, /blah/) {x}
    assert_equal true, r
  end

  it 'should fail if raised type is of negated type' do
    r = refute_raise(NameError, /blah/) {x}
    assert r.class == Tiramisu::GenericFailure
    assert r.reason.any? {|l| l =~ /Not expected a NameError to be raised/}
  end

  it 'should fail if error message matches negated one' do
    r = refute_raise(ArgumentError, /undefined local variable or method/) {x}
    assert r.class == Tiramisu::GenericFailure
    assert r.reason.any? {|l| l =~ /Not expected raised exception to match \/undefined/}
  end
end
