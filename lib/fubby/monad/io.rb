require_relative '../utils'

module F_IO
  # bind :: M(a) -> (a -> M(b)) -> M(b)
  def bind
    ->(m1, f) {
      -> {
        f.(m1.()).()
      }.add_prop.(:to_s, ->() { m1.to_s + ' >>= ' + f.to_s })
    }
  end

  # shovel :: M(a) -> M(b) -> M(b)
  def shovel
    ->(m1, m2) {
      bind.(m1, ->(_) { m2 }).add_prop.(:to_s, ->() { m1.to_s + ' >> ' + m2.to_s })
    }
  end

  # input :: M(String)
  def input
    _input = ->() { gets.chomp }.add_prop.(:to_s, ->() { 'F_IO::input(String)' })

    ->() { _input }.add_prop.(:to_s, ->() { '() -> F_IO::input(String)' })
  end

  # output :: String -> M(())
  def output
    ->(x) {
      ->() { print x }.add_prop.(:to_s, ->() { 'F_IO::output()' })
    }.add_prop.(:to_s, ->() { 'String -> F_IO::output()' })
  end
end
