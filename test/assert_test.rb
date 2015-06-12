describe :assert do

  it 'pass ==' do
    x = mock(:==, :x)
    x == :x
    x.verify
  end

  it 'pass ===' do
    x = mock(:===, :x)
    x === :x
    x.verify
  end

  it 'pass !=' do
    x = mock(:!=, :x)
    x != :x
    x.verify
  end

  it 'pass >' do
    x = mock(:>, :x)
    x > :x
    x.verify
  end

  it 'pass >=' do
    x = mock(:>=, :x)
    x >= :x
    x.verify
  end

  it 'pass <' do
    x = mock(:<, :x)
    x < :x
    x.verify
  end

  it 'pass <=' do
    x = mock(:<=, :x)
    x <= :x
    x.verify
  end

  it 'pass eql?' do
    x = mock(:eql?, :x)
    x.eql? :x
    x.verify
  end

  it 'pass equal?' do
    x = mock(:equal?, :x)
    x.equal? :x
    x.verify
  end

end
