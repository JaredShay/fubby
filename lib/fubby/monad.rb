require_relative './utils'
require_relative './core'
require_relative './math'

module Maybe
  U = Class.new { extend Utils }
  private_constant :U

  M = Class.new { extend Math }
  private_constant :M

  C = Class.new { extend Core }
  private_constant :C

  # unit :: a -> M(a)
  def unit
    ->(x) {
      x ? _just.(x) : _nothing.()
    }
  end

  # bind :: M(a) -> (a -> M(b)) -> M(b)
  def bind
    ->(m, f) {
      v = m.()
      v ? f.(v) : _nothing.()
    }
  end

  # lift2 :: (a -> a) -> M(a) -> M(a) -> M(a)
  def lift2
    C.curry.(
      ->(f, mx, my) {
        bind.(mx, ->(x) {
          bind.(my, ->(y) {
            unit.(f.(x, y))
          })
        })
      }
    )
  end

  # add :: M(Number) -> M(Number) -> M(Number)
  def add
    lift2.(M.add)
  end

  # subtract :: M(Number) -> M(Number) -> M(Number)
  def subtract
    _subtract = ->(x, y) { x - y }

    lift2.(_subtract)
  end

  # safe_division :: M(Number) -> M(Number) -> M(Number)
  def safe_division
    ->(m1, m2) {
      division = ->(x, y) { y == 0 ? nil : x / y }

      lift2.(division, m1, m2)
    }
  end

  private

  def _just
    ->(x) {
      f = ->() { x }
      U.add_prop.(f, :to_s, ->()  { 'just(' + x.to_s + ')' })
      #U.add_prop.(f, :bind, ->(f) { f.(x) }
      f
    }
  end

  def _nothing
    ->() {
      f = ->() {}
      U.add_prop.(f, :to_s,   ->()  { 'nothing()' })
      #U.add_prop.(f, :bind,   ->(f) { })
      #U.add_prop.(f, :return, ->()  {  })
      f
    }
  end
end
