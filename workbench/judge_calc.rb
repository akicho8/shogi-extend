require "#{__dir__}/setup"
judge_calc = JudgeCalc.new(win: 3, lose: 7)
judge_calc.win                  # => 3
judge_calc.lose                 # => 7
judge_calc.draw                 # => 0
judge_calc.count                # => 10
judge_calc.ratio                # => 0.3
