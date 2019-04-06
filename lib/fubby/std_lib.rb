require_relative './core.rb'

module StdLib
  C = Class.new { extend Core }
  private_constant :C

  # map :: (a -> b) -> [a] -> [b]
  def map
    C.curry.(
      ->(f, xs) {
        _f = ->(acc, x) {
          concat.(acc, [f.(x)])
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
          f.(x) == true ? concat.(acc, [x]) : acc
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

  # concat :: [a] -> [a] -> [a]
  def concat
    ->(a1, a2) { a1 + a2 }
  end

  # length :: [a] -> Number
  def length
    ->(xs) {
      C.fold.(0, ->(acc, _) { acc + 1 }, xs)
    }
  end

  # reverse :: [a] -> [a]
  def reverse
    ->(xs) {
      length.(xs) <= 1 ? xs : concat.(reverse.(xs[1..-1]), [head.(xs)])
    }
  end

  # head :: [a] -> a
  def head
    ->(xs) { xs[0] }
  end

  # tail :: [a] -> a
  def tail
    C.compose.(head, reverse)
  end

  # take :: [a] -> [a]
  def take
    _take = ->(n, xs, acc) {
      acc.length == n ? acc : _take.(n, tail.(xs), concat.(acc, head.(xs))
    }

    C.curry.(
      ->(n, xs) { _take.(n, xs, []) }
    )
  end
end
