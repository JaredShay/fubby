class Proc
  # This is defined on Proc to allow chaining an add_prop call to a lambda
  # definition. This is useful for debugging as you can do things such as:
  #
  #  f = ->(x) { x }.add_prop(:to_s, ->() { 'Identity' }
  #  f.to_s => 'Identity'
  def add_prop
    ->(prop, f) {
      self.tap { |x| x.define_singleton_method(prop, &f) }
    }
  end
end
