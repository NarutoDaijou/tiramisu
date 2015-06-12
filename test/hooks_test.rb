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

  it 'calls named hooks' do
    called = 0
    spec rand do
      after(:b) {called += 1}
      test(:a) {}
      test(:b) {}
      run(:a)
      run(:b)
    end
    assert_equal 1, called
  end

  it 'prefers named hooks over wildcard ones' do
    called = nil
    spec rand do
      around(:a) {called = :named}
      around {called = :wildcard}
      test(:a) {}
      run(:a)
    end
    assert_equal :named, called
  end
end
