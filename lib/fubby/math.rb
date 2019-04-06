require_relative './core'

module Math
  C = Class.new { extend Core }

  # add :: Int -> Int -> Int
  def add
    C.curry.(->(x, y) { x + y })
  end

  # subtract :: Int -> Int -> Int
  def subtract
    C.curry.(->(x, y) { x - y })
  end

  # multiply :: Int -> Int -> Int
  def multiply
    C.curry.(->(x, y) { x * y })
  end

  # divide :: Int -> Int -> Int
  def divide
    C.curry.(->(x, y) { x / y })
  end
end
