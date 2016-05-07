require_relative '../test_helper.rb'
require_relative '../../lib/fubby/std_lib.rb'

class T
  extend StdLib
end

class LengthTest < MiniTest::Test
  def test_zero_length_array
    assert_equal 0, T.length.([])
  end

  def test_array_with_one_element
    assert_equal 1, T.length.([1])
  end

  def test_array_with_two_elements
    assert_equal 2, T.length.(['a', 'b'])
  end

  def test_array_with_three_elements
    assert_equal 3, T.length.([1, 2, 3])
  end
end

class MapTest < MiniTest::Test
  def test_zero_length_array
    assert_equal [], T.map.(->(x) { x }, [])
  end

  def test_array_with_one_element
    assert_equal [2], T.map.(->(x) { x + 1 }, [1])
  end

  def test_currying
    double = T.map.(->(x) { x * 2 })

    assert_equal [2, 4], double.([1, 2])
  end
end

class SelectTest < MiniTest::Test
  def test_zero_length_array
    assert_equal [], T.select.(->(x) { x == 1 }, [])
  end
end
