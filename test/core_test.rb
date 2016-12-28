require_relative './test_helper.rb'
require_relative './../lib/fubby/core.rb'

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
    def test_reducing_a_zero_length_array
      assert_raises(NoMethodError) { T.reduce.(->(x) { x }, []) }
    end

    def test_reducing_an_array_of_length_one
      assert_equal 1, T.reduce.(->(x, _) { x }, [1])
    end

    def test_reducing_an_array_of_length_two
      assert_equal 3, T.reduce.(->(x, y) { x + y }, [1, 2])
    end

    def test_currying_the_reduce_function
      sum = T.reduce.(->(x, y) { x + y })

      assert_equal 6, sum.([1, 2, 3])
    end
  end

  class FoldTest < MiniTest::Test
    def test_folding_a_zero_length_array
      assert_equal 'acc', T.fold.('acc', ->(x, _) { x }, [])
    end

    def test_folding_an_array_of_length_one
      assert_equal 1, T.fold.(0, ->(x, y) { x + y }, [1])
    end

    def test_folding_an_array_of_length_two
      assert_equal 4, T.fold.(1, ->(x, y) { x + y }, [1, 2])
    end

    def test_currying_the_fold_function
      sum = T.fold.(0, ->(x, y) { x + y })

      assert_equal 4, sum.([2, 2])
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

  class FlipTest < MiniTest::Test
    def test_flip_with_one_args
      f = T.flip.(->(x) { x })

      assert_equal f.(1), 1
    end

    def test_flip_with_two_args
      f = T.flip.(->(x, y) { x - y })

      assert_equal f.(2, 4), 2
    end
  end
end
