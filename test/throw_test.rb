describe :throws do
  def throwstest *args, &block
    catch :__tiramisu_status__ do
      Tiramisu::Assert.new(nil, :assert, block).throw(*args)
    end
  end

  it 'should pass when any symbol expected and something thrown' do
    r = throwstest {throw :x}
    assert_equal true, r
  end

  it 'should pass when specific symbol expected and thrown' do
    r = throwstest(:x) {throw :x}
    assert_equal true, r
  end

  it 'should fail when any symbol expected but nothing thrown' do
    r = throwstest {}
    assert r.reason.any? {|l| l =~ /Expected a symbol to be thrown/}
  end

  it 'should fail when specific symbol expected but nothing thrown' do
    r = throwstest(:x) {}
    assert r.reason.any? {|l| l =~ /Expected a symbol to be thrown/}
  end

  it 'should pass when correct symbol and value thrown' do
    r = throwstest(:x, :y) {throw :x, :y}
    assert_equal true, r
  end

  it 'should fail when wrong symbol thrown' do
    r = throwstest(:x) {throw :y}
    assert r.reason.any? {|l| l =~ /Instead :y thrown/}
  end

  it 'should fail when wrong value thrown' do
    r = throwstest(:x, :z) {throw :x, :y}
    assert r.reason.any? {|l| l =~ /Expected value: :z/}
  end
end
