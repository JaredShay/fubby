require_relative '../utils'
require_relative '../monad/monad'

module Maybe
  M = Class.new { extend Monad }; private_constant :M

  # unit :: a -> M(a)
  def unit
    ->(x) {
      x ? _just.(x) : _nothing.()
    }
  end

  # bind :: M(a) -> (a -> M(b)) -> M(b)
  def bind
    ->(m, f) {
      m.() ? f.(m.()) : _nothing.()
    }
  end

  # lift :: (a -> a -> a) -> M(a) -> M(a) -> M(a)
  def lift
    M.lift.(bind, unit)
  end

  private

  # _just :: a -> M(a)
  def _just
    ->(x) {
      ->() { x }.add_prop.(:to_s, ->() { 'just(' + x.to_s + ')' })
    }
  end

  # _nothing :: a -> M(a)
  def _nothing
    ->() {
      ->() {}.add_prop.(:to_s, ->()  { 'nothing()' })
    }
  end
end
