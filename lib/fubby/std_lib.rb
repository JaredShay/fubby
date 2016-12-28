require_relative './core.rb'
require_relative './array_utils.rb'

module StdLib
  C = Class.new { extend Core }
  private_constant :C

  A = Class.new { extend ArrayUtils }
  private_constant :A

  # length :: [a] -> Number
  def length
    ->(xs) {
      C.fold.(0, ->(acc, _) { acc + 1 }, xs)
    }
  end

  # map :: (a -> b) -> [a] -> [b]
  def map
    C.curry.(
      ->(f, xs) {
        _f = ->(acc, x) {
          A.concat.(acc, [f.(x)])
        }

        C.fold.([], _f, xs)
      }
    )
  end

  # select :: (a -> Bool) -> [a] -> [a]
  def select
    C.curry.(
      ->(f, xs) {
        _f = ->(acc, x) {
          f.(x) == true ? A.concat.(acc, [x]) : acc
        }

        C.fold.([], _f, xs)
      }
    )
  end

  # reject :: (a -> Bool) -> [a] -> [a]
  def reject
    C.curry.(->(f, xs) { xs - select.(f, xs) })
  end

  # any :: (a -> Bool) -> Bool
  def any
    C.curry.(
      ->(f, xs) {
        _f = ->(acc, x) {
          f.(x) ? true : acc
        }

        C.fold.(_f, xs, false)
      }
    )
  end

  # any :: (a -> Bool) -> Bool
  def f_all
    C.curry.(
      ->(f, xs) {
        !any.(->(x) { x == false }, map.(f, xs))
      }
    )
  end

  # head :: [a] -> a
  def head
    ->(xs) { xs[0] }
  end

  # reverse :: [a] -> [a]
  def reverse
    ->(xs) {
      length.(xs) <= 1 ? xs : A.concat.(reverse.(xs[1..-1]), [head.(xs)])
    }
  end

  # tail :: [a] -> a
  def tail
    C.compose.(head, reverse)
  end
end
