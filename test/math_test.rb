require_relative './test_helper.rb'
require_relative './../lib/fubby/math.rb'

class T
  extend Math
end

module Test
  class MathTest < MiniTest::Test
    def test_add
      assert_equal 4, T.add.(2, 2)
    end

    def test_currying_add
      add_2 = T.add.(2)
      assert_equal 4, add_2.(2)
    end

    def test_subract
      assert_equal 0, T.subtract.(2, 2)
    end

    def test_currying_subtract
      subtract_from_2 = T.subtract.(2)
      assert_equal 0, subtract_from_2.(2)
    end

    def test_multiply
      assert_equal 4, T.multiply.(2, 2)
    end

    def test_currying_multiply
      multiply_2 = T.multiply.(2)
      assert_equal 4, multiply_2.(2)
    end

    def test_divide
      assert_equal 1, T.divide.(2, 2)
    end

    def test_currying_multiply
      divide_2 = T.divide.(2)
      assert_equal 1, divide_2.(2)
    end
  end
end
