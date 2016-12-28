require_relative '../core'

module Monad
  C = Class.new { extend Core }; private_constant :C

  # lift :: (M(a) -> (a -> M(b)) -> M(b)) -> (a -> M(a)) -> (a -> a -> a) -> M(a) -> M(a) -> M(a)
  def lift
    C.curry.(
      ->(bind, unit, f, mx, my) {
        bind.(mx, ->(x) {
          bind.(my, ->(y) {
            unit.(f.(x, y))
          })
        })
      }
    )
  end
end
