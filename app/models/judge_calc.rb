# judge_calc = JudgeCalc.new(win: 3, lose: 7)
# judge_calc.win                  # => 3
# judge_calc.lose                 # => 7
# judge_calc.draw                 # => 0
# judge_calc.count                # => 10
# judge_calc.ratio                # => 0.3

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
    @ratio ||= yield_self do
      if count.nonzero?
        win.fdiv(count)
      end
    end
  end
end
