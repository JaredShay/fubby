require_relative './core.rb'
require_relative './array_utils.rb'

module StdLib
  C = Class.new { extend Core }
  private_constant :C

  A = Class.new { extend ArrayUtils }
  private_constant :A

  # length :: [a] -> Number
  def length
    ->(x) {
      C.fold.(0, ->(memo, _) { memo + 1 }, x)
    }
  end

  # map :: (a -> b) -> [a] -> [b]
  def map
    C.curry.(
      ->(f, x) {
        fx = ->(memo, x) {
          A.concat.(memo, [f.(x)])
        }

        C.fold.([], fx, x)
      }
    )
  end

  # select :: (a -> Bool) -> [a] -> [a]
  def select
    C.curry.(
      ->(f, x) {
        fx = ->(memo, x) {
          f.(x) == true ? A.concat.(memo, [x]) : memo
        }

        C.fold.([], fx, x)
      }
    )
  end

  # reject :: (a -> Bool) -> [a] -> [a]
  def reject
    C.curry.(->(f, x) { x - select.(f, x) })
  end

  # any :: (a -> Bool) -> Bool
  def any
    C.curry.(
      ->(f, x) {
        fx = ->(memo, x) {
          f.(x) ? true : memo
        }

        C.fold.(fx, x, false)
      }
    )
  end

  # any :: (a -> Bool) -> Bool
  def f_all
    C.curry.(
      ->(f, x) {
        !any.(->(x) { x == false }, map.(f, x))
      }
    )
  end

  # head :: [a] -> a
  def head
    ->(x) { x[0] }
  end

  # reverse :: [a] -> [a]
  def reverse
    ->(x) {
      length.(x) <= 1 ? x : A.concat.(reverse.(x[1..-1]), [head.(x)])
    }
  end

  # tail :: [a] -> a
  def tail
    C.compose.(head, reverse)
  end

  # TODO: figure out how to handle Strings and Chars
  def str_head
    ->(x) { x[0] }
  end

  # TODO implement this without `downcase`
  # downcase :: String -> String
  def downcase
    ->(x) { x.downcase }
  end

  # TODO implement this without `capitalize`
  # downcase :: String -> String
  def upcase
    ->(x) { x.capitalize }
  end
end
