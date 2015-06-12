describe :skip do

  it 'should skip inside spec' do
    r, w = IO.pipe
    fork do
      r.close
      s = Clover.define_spec :skip_spec, proc {
        test(:a) {}
        skip
        test(:b) {}
      }
      w.print({skips: Clover.skips.size, tests: s.tests.size}.to_json)
    end
    w.close
    data = JSON.parse(r.read)
    assert_equal 1, data['skips']
    assert_equal 1, data['tests']
  end

  it 'should skip inside test' do
    r, w = IO.pipe
    fork do
      r.close
      buffer = []
      Clover.define_and_register_a_spec :skip_test, proc {
        test :x do
          buffer << 'a'
          skip
          buffer << 'b'
        end
      }
      Clover.run
      w.print({skips: Clover.skips.size, buffer: buffer}.to_json)
    end
    w.close
    data = JSON.parse(r.read)
    assert_equal 1, data['skips']
    assert_equal ["a"], data['buffer']
  end
end
