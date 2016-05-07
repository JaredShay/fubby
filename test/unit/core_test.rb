require_relative '../test_helper.rb'
require_relative '../../lib/fubby/core.rb'

class T
  extend Core
end

module Test
  class IdentityTest < MiniTest::Test
    def test_success
      assert_equal 'x', T.identity.('x')
    end

    def test_fail
      assert 'x' != T.identity.('y')
    end
  end

  class CurryTest < MiniTest::Test
    def test_defining_a_method_with_no_args
      f = T.curry.(-> { 'x' })

      assert_equal 'x', f.()
    end

    def test_defining_a_method_with_one_argument
      f = T.curry.(->(x) { x })

      assert_equal 'x', f.('x')
      assert_equal 'x', f.().('x')
      assert_equal 'x', f.().().('x')
    end

    def test_defining_a_method_with_two_arguments
      f = T.curry.(->(x, y) { x + y })

      assert_equal 3, f.(1, 2)
      assert_equal 3, f.().(1, 2)
      assert_equal 3, f.().().(1, 2)
      assert_equal 3, f.(1).(2)
      assert_equal 3, f.().(1).(2)
      assert_equal 3, f.(1).().(2)
      assert_equal 3, f.(1).().().(2)
      assert_equal 3, f.().(1).().(2)
      assert_equal 3, f.().(1).().().(2)
    end

    def test_defining_a_method_with_three_arguments
      f = T.curry.(->(x, y, z) { x + y + z })

      assert_equal 6, f.(1, 2, 3)
      assert_equal 6, f.().(1, 2, 3)
      assert_equal 6, f.().().(1, 2, 3)
      assert_equal 6, f.(1, 2).(3)
      assert_equal 6, f.().(1, 2).(3)
      assert_equal 6, f.().(1, 2).().(3)
      assert_equal 6, f.(1, 2).().(3)
      assert_equal 6, f.(1).(2, 3)
      assert_equal 6, f.().(1).(2, 3)
      assert_equal 6, f.().(1).().(2, 3)
      assert_equal 6, f.(1).(2).(3)
      assert_equal 6, f.().(1).(2).(3)
      assert_equal 6, f.().(1).().(2).(3)
      assert_equal 6, f.().(1).().(2).().(3)
      assert_equal 6, f.(1).().(2).(3)
      assert_equal 6, f.(1).().(2).().(3)
      assert_equal 6, f.(1).(2).().(3)
    end
  end

  class ReduceTest < MiniTest::Test
    def test_reducing_a_zero_element_array_with_no_memo
      assert_equal nil, T.reduce.(nil, ->(x, y) { x + y }, [])
    end

    def test_reducing_a_zero_element_array_with_a_memo
      assert_equal 'memo', T.reduce.('memo', ->(x, y) { x + y }, [])
    end

    def test_reducing_a_one_element_array_with_no_memo
      assert_equal 1, T.reduce.(nil, ->(x, y) { x + y }, [1])
    end

    def test_reducing_a_one_element_array_with_a_memo
      assert_equal 2, T.reduce.(1, ->(x, y) { x + y }, [1])
    end

    def test_reducing_a_two_element_array_with_no_memo
      assert_equal 3, T.reduce.(nil, ->(x, y) { x + y }, [1, 2])
    end

    def test_reducing_a_two_element_array_with_a_memo
      assert_equal 6, T.reduce.(1, ->(x, y) { x + y }, [2, 3])
    end

    def test_reducing_a_three_element_array_with_no_memo
      assert_equal 6, T.reduce.(nil, ->(x, y) { x + y }, [1, 2, 3])
    end

    def test_reducing_a_three_element_array_with_a_memo
      assert_equal 10, T.reduce.(1, ->(x, y) { x + y }, [2, 3, 4])
    end

    def test_currying
      sum = T.reduce.(nil, ->(x, y) { x + y })

      assert_equal 6, sum.([1, 2, 3])
    end
  end

  class ComposeTest < MiniTest::Test
    def test_composing_a_single_function
      f = T.compose.(->(x) { x })

      assert_equal 'x', f.('x')
    end

    def test_composing_two_functions
      f = T.compose.(->(x) { x + 1 }, ->(x) { x * 2 })

      assert_equal 5, f.(2)
    end

    def test_composing_three_functions
      f = T.compose.(->(x) { x + 1 }, ->(x) { x * 2 }, ->(x) { x + 3 })

      assert_equal 11, f.(2)
    end
  end
end
