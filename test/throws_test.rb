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

  it 'should pass when correct symbol and value thrown' do
    r = throwstest(:x, :y) {throw :x, :y}
    assert_equal true, r
  end

  it 'should fail when wrong symbol thrown' do
    r = throwstest(:x) {throw :y}
    assert r.reason.any? {|l| l =~ /Instead :y symbol thrown/}
  end

  it 'should fail when no symbol thrown' do
    r = throwstest(:x) {}
    assert r.reason.any? {|l| l =~ /Expected.+to throw :x symbol/}
  end

  it 'should fail when wrong value thrown' do
    r = throwstest(:x, :z) {throw :x, :y}
    assert r.reason.any? {|l| l =~ /Expected value: :z/}
  end
end
