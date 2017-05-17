module Core
  # identity :: a -> a
  def identity
    ->(x) { x }
  end

  # curry :: (a -> b) -> (a -> b)
  def curry
    _curry = ->(f, *given_args) {
      ->(*remaining_args) {
        total_args = given_args + remaining_args

        total_args.length == f.arity ? f.(*total_args) : _curry.(f, *total_args)
      }
    }

    ->(f) {
      ->(*xs) {
        f.arity == xs.length ? f.(*xs) : _curry.(f, *xs)
      }
    }
  end

  # reduce :: (b -> a), [b] -> a
  def reduce
    _reduce = ->(acc, f, xs){
      xs == [] ? acc : _reduce.(f.(acc, xs[0]), f, xs[1..-1])
    }

    curry.(->(f, xs) {
      _reduce.(xs[0], f, xs[1..-1])
    })
  end

  # fold :: a, (b -> a), [b] -> a
  def fold
    curry.(->(acc, f, xs) {
      xs == [] ? acc : reduce.(f, [acc] + xs)
    })
  end

  # compose :: [(a -> b)] -> (a -> b)
  def compose
    ->(fs) {
      _compose = ->(*x, fs) {
        fs.length == 1 ? fs[0].(*x) : fs[0].(_compose.(*x, fs[1..-1]))
      }

      ->(*x) { _compose.(*x, fs) }
    }
  end

  # flip :: (a -> b) -> (a -> b)
  def flip
    ->(f) {
      _reverse = ->(xs) {
        xs.length == 1 ? xs : [xs[-1]] + _reverse.(xs[0...-1])
      }

      ->(*args) {
        f.(*_reverse.(args))
      }
    }
  end
end
