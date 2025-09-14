require "rails_helper"

RSpec.describe JudgeCalc, type: :model do
  it "works" do
    judge_calc = JudgeCalc.new(win: 3, lose: 7)
    assert { judge_calc.win   == 3   }
    assert { judge_calc.lose  == 7   }
    assert { judge_calc.draw  == 0   }
    assert { judge_calc.count == 10  }
    assert { judge_calc.ratio == 0.3 }
  end
end
