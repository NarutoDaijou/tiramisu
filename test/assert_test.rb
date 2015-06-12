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

  it 'pass start_with?' do
    x = mock(:start_with?, :x)
    x.start_with? :x
    x.verify
  end

  it 'pass end_with?' do
    x = mock(:end_with?, :x)
    x.end_with? :x
    x.verify
  end

  it 'pass respond_to?' do
    x = mock(:respond_to?, :__id__, true)
    x.respond_to? :__id__, true
    x.verify
  end
end
