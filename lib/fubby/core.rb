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

  # reduce :: a, (b -> a), [b] -> a
  def reduce
    curry.(->(memo, f, array) {
      if memo == nil
        case array.length
        when 0 then nil
        when 1 then array[0]
        else reduce.(f.(array[0], array[1]), f, array[2..-1])
        end
      else
        case array.length
        when 0 then memo
        else reduce.(f.(memo, array[0]), f, array[1..-1])
        end
      end
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
