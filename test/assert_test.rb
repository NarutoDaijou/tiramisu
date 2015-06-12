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

  it 'pass =~' do
    x = mock(:=~, :x)
    x =~ :x
    x.verify
  end

  it 'pass match' do
    x = mock(:match, :x)
    x.match :x
    x.verify
  end

  it 'pass any?' do
    m = mock(:any?)
    m.any?
    m.verify
  end

  it 'pass all?' do
    x = mock(:all?, :x)
    x.all? :x
    x.verify
  end

end
