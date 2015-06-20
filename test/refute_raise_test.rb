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

  it 'should fail if exception of specific type negated but nothing raised' do
    r = raisetest(NameError) {}
    assert r.class == Tiramisu::Failures::Generic
    assert r.reason.any? {|l| l =~ /Expected a exception to be raised/}
  end

  it 'should fail if exception with specific message negated but nothing raised' do
    r = raisetest(nil, 'x') {}
    assert r.class == Tiramisu::Failures::Generic
    assert r.reason.any? {|l| l =~ /Expected a exception to be raised/}
  end

  it 'should fail if a validation block provided but nothing raised' do
    r = raisetest(proc {}) {}
    assert r.class == Tiramisu::Failures::Generic
    assert r.reason.any? {|l| l =~ /Expected a exception to be raised/}
  end

  it 'should pass if it raises a exception type different from negated one' do
    r = raisetest(ArgumentError) {x}
    assert_equal true, r
  end

  it 'should fail if it raises a exception of same type as negated one' do
    r = raisetest(NameError) {x}
    assert r.class == Tiramisu::Failures::Generic
    assert r.reason.any? {|l| l =~ /Not expected raised exception to be of type NameError/}
  end

  it 'should pass if it raises a exception with a message different from negated one' do
    r = raisetest(nil, 'blah') {x}
    assert_equal true, r
  end
end
