require_relative './core.rb'
require_relative './std_lib.rb'

module Lazy
  C = Class.new { extend Core }
  private_constant :C

  S = Class.new { extend StdLib }
  private_constant :S

  # lazify :: (a -> b) -> [a] -> Int -> [c]
  def lazify
    ->(fx) {
      C.curry.(
        ->(fy, xs, n) {
          fx.call(fy, nth_from_array_or_range.call(xs, n))
        }
      )
    }
  end

  # This function breaks the type system so the `Range` class can be used. This
  # is entirely for infinite collections eg. (1..Float::INFINITY)
  # nth_from_array_or_range :: ([a] || Range(a)) -> Int -> [a]
  def nth_from_array_or_range
    C.curry.(
      ->(xs, n) {
        xs.is_a?(Range) ? xs.first(n) : S.take.(xs, n)
      }
    )
  end

  # map :: (a -> b) -> [a] -> Int -> [b]
  def lazy_map
    lazify.call(S.map)
  end

  # select :: (a -> Bool) -> [a] -> Int -> [a]
  def lazy_select
    lazify.call(S.select)
  end

  # reject :: (a -> Bool) -> [a] -> Int -> [a]
  def lazy_reject
    lazify.call(S.reject)
  end
end
