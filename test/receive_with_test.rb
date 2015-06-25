describe :receive_with do

  it 'should pass when called with correct arguments' do
    this = self
    spec rand do
      test :test do
        mock = expect(1).to_receive(:+).with(1)
        mock + 1
      end
      this.assert_equal :__tiramisu_passed__, run(:test)
    end
  end

  it 'should fail when called without arguments' do
    this = self
    spec rand do
      test :test do
        mock = expect([]).to_receive(:join).with('')
        mock.join
      end
      this.assert run(:test).reason.any? {|l| l =~ /Looks like :join message never was called with expected arguments/}
    end
  end

  it 'should fail when called with wrong arguments' do
    this = self
    spec rand do
      test :test do
        mock = expect([]).to_receive(:join).with('')
        mock.join('/')
      end
      this.assert run(:test).reason.any? {|l| l =~ /Looks like :join message never was called with expected arguments/}
    end
  end

  it 'should pass when all expected messages received with expected arguments' do
    this = self
    spec rand do
      test :test do
        mock = expect([]).to_receive(:include?, :concat).with([1], [[1]])
        mock.include? 1
        mock.concat [1]
      end
      this.assert_equal :__tiramisu_passed__, run(:test)
    end
  end
end
