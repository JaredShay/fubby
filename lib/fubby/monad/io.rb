require_relative '../utils'

module F_IO
  U = Class.new { extend Utils }
  private_constant :U

  extend self

  # bind :: M(a) -> (a -> M(b)) -> M(b)
  def bind
    ->(m1, f) {

      io_action = -> {
        r = m1.()
        f.(r).()
      }

      U.add_prop.(io_action, :to_s, ->() { m1.to_s + ' >>= ' + f.to_s })

      io_action
    }
  end

  # shovel :: M(a) -> M(b) -> M(b)
  def shovel
    ->(m1, m2) {
      r = bind.(m1, ->(_) { m2 })

      U.add_prop.(r, :to_s, ->() { m1.to_s + ' >> ' + m2.to_s })

      r
    }
  end

  # input :: M(String)
  def input
    f = ->() {
      r = ->() { gets.chomp }

      U.add_prop.(r, :to_s, ->() { 'input' })

      r
    }

    U.add_prop.(f, :to_s, ->() { '-> { input() }' })

    f
  end

  # output :: String -> M(())
  def output
    f = ->(x) {
      r = ->() { print x }

      U.add_prop.(r, :to_s, ->() { 'output' })

      r
    }

    U.add_prop.(f, :to_s, ->() { '-> a { output(a) }' })

    f
  end
end

#puts F_IO.output.('x').to_s
#x = F_IO.bind.(F_IO.input.(), F_IO.output)
#puts x.to_s
#x.()

x = F_IO.shovel.(F_IO.output.('hello'), F_IO.output.(' world'))
puts x.to_s
x.()
