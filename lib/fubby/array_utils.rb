module ArrayUtils
  # concat :: [a] -> [a] -> [a]
  def concat
    ->(a1, a2) { a1 + a2 }
  end
end
