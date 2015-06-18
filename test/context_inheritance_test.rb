describe :context_inheritance_test do

  it 'inherits from parent spec' do
    x = nil
    spec rand do
      define_method(:set_x) {x = true}
      context rand do
        allocate.send(:set_x)
      end
    end
    assert_equal true, x
  end

end
