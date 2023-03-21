require "rails_helper"

RSpec.describe StandardDeviation do
  let :sdc do
    StandardDeviation.new([1, 2, 3])
  end

  it "works" do
    is_asserted_by { sdc.sd                 == 0.816496580927726  }
    is_asserted_by { sdc.avg                == 2.0                }
    is_asserted_by { sdc.sum                == 6                  }
    is_asserted_by { sdc.deviation_score(2) == 50.0               }
    is_asserted_by { sdc.appear_ratio(2)    == 0.3333333333333333 }
  end
end
