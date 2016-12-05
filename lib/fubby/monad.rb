module Maybe
  class Just
    def self.unit(x); new(x); end

    def initialize(x); @x = x; end

    def bind(f); f.(@x); end
  end

  class Nothing
    def self.unit(); new; end

    def bind(_); self; end
  end

  def just
    Just
  end

  def nothing
    Nothing
  end

  def add
    ->(m1, m2) {
      m1.bind(->(x) {
        m2.bind(->(y) {
          Just.unit(x + y)
        })
      })
    }
  end

  def safe_division
    ->(m1, m2) {
      m1.bind(->(x) {
        m2.bind(->(y) {
          y == 0 ? Nothing.unit() : Just.unit(x / y)
        })
      })
    }
  end
end

class T
  extend Maybe
end

x = T.just.unit(1)
y = T.just.unit(1)
puts x.inspect
