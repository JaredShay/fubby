require_relative './core.rb'
require_relative './std_lib.rb'

module Lazy
  C = Class.new { extend Core }
  private_constant :C

  S = Class.new { extend StdLib }
  private_constant :S

  def lazify
    ->(fx) {
      C.curry.(
        ->(fy, xs, n) {
          fx.call(fy, nth_from_array_or_range.call(xs, n))
        }
      )
    }
  end

  def nth_from_array_or_range
    C.curry.(
      ->(xs, n) {
        xs.is_a?(Range) ? xs.first(n) : xs[0...n]
      }
    )
  end

  def lazy_map
    lazify.call(S.map)
  end

  def lazy_select
    lazify.call(S.select)
  end
end
