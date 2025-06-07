class JudgeCalc
  def initialize(hv)
    @hv = hv
  end

  def win
    @hv[:win] || 0
  end

  def lose
    @hv[:lose] || 0
  end

  def draw
    @hv[:draw] || 0
  end

  def count
    @count ||= win + lose + draw
  end

  def ratio
    if count.nonzero?
      win.fdiv(count)
    end
  end
end
