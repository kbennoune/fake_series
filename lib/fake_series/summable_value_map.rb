module SummableValueMap
  def to_f
    values.sum.to_f
  end

  def to_i
    values.sum.to_i
  end

  def to_s
    values.sum.to_f.to_s
  end
end
