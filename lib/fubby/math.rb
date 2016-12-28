require_relative './core'

module Math
  C = Class.new { extend Core }

  # add :: Fixnum -> Fixnum -> Fixnum
  def add
    C.curry.(->(x, y) { x + y })
  end

  # subtract :: Fixnum -> Fixnum -> Fixnum
  def subtract
    C.curry.(->(x, y) { x - y })
  end

  # multiply :: Fixnum -> Fixnum -> Fixnum
  def multiply
    C.curry.(->(x, y) { x * y })
  end

  # divide :: Fixnum -> Fixnum -> Fixnum
  def divide
    C.curry.(->(x, y) { x / y })
  end
end
