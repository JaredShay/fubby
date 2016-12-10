module Utils
  def add_prop
    ->(x, prop, f) {
      x.define_singleton_method(prop, &f)
    }
  end
end
