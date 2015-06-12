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

end
