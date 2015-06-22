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

  it 'should fail when something thrown' do
    r = refute_throw {throw :x}
    assert r.reason.any? {|l| l =~ /Not expected a symbol to be thrown/}
  end

  it 'should pass when thrown symbol does not match negated one' do
    r = refute_throw(:x) {throw :y}
    assert_equal true, r
  end

  it 'should fail when thrown symbol does match negated one' do
    r = refute_throw(:x) {throw :x}
    assert r.reason.any? {|l| l =~ /Not expected :x to be thrown/}
  end

  it 'should fail when thrown symbol does match negated one and value does not' do
    r = refute_throw(:x, :a) {throw :x, :b}
    assert r.reason.any? {|l| l =~ /Not expected :x to be thrown/}
  end

  it 'should fail when a negated symbol expected and nothing thrown' do
    r = refute_throw(:x) {}
    assert r.reason.any? {|l| l =~ /Expected a symbol to be thrown/}
  end

  it 'should fail when a negated value expected and nothing thrown' do
    r = refute_throw(nil, 'blah') {}
    assert r.reason.any? {|l| l =~ /Expected a symbol to be thrown/}
  end
end
