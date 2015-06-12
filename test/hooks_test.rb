describe :hooks do
  it 'calls wildcard hooks' do
    called = 0
    spec rand do
      before {called += 1}
      test(:a) {}
      test(:b) {}
      run(:a)
      run(:b)
    end
    assert_equal 2, called
  end
end
