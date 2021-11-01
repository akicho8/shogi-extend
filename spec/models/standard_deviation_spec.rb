require "rails_helper"

RSpec.describe StandardDeviation do
  let :sdc do
    StandardDeviation.new([1, 2, 3])
  end

  it do
    assert { sdc.sd                 == 0.816496580927726  }
    assert { sdc.avg                == 2.0                }
    assert { sdc.sum                == 6                  }
    assert { sdc.deviation_score(2) == 50.0               }
    assert { sdc.appear_ratio(2)    == 0.3333333333333333 }
  end
end
