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
      ->(*x) {
        f.arity == x.length ? f.(*x) : _curry.(f, *x)
      }
    }
  end

  # reduce :: (b -> a), [b] -> a
  def reduce
    _reduce = ->(acc, f, array){
      array == [] ? acc : _reduce.(f.(acc, array[0]), f, array[1..-1])
    }

    curry.(->(f, array) {
      _reduce.(array[0], f, array[1..-1])
    })
  end

  # fold :: a, (b -> a), [b] -> a
  def fold
    curry.(->(acc, f, array) {
      array == [] ? acc : reduce.(f, [acc] + array)
    })
  end

  # TODO: figure out how to notate many args. [f] isn't correct here.
  # compose :: [f] -> (a -> b)
  def compose
    ->(*f) {
      _compose = ->(x, *f) {
        f.length == 1 ? f[0].(x) : f[0].(_compose.(x, *f[1..-1]))
      }

      ->(x) { _compose.(x, *f) }
    }
  end

  # flip :: (a -> b) -> (a -> b)
  def flip
    ->(f) {
      ->(*args) {
        f.(*reverse.(args))
      }
    }
  end
end
