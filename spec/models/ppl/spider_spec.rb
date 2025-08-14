require "rails_helper"

RSpec.describe Ppl::Spider, type: :model do
  it "works" do
    rows = Ppl::Spider.new(generation: 66, max: 1, verbose: false, sleep: 0).call
    attrs = rows.sole
    assert { attrs[:result_key] == "維"                 }
    assert { attrs[:start_pos]  == 1                    }
    assert { attrs[:name]       == "古賀悠聖"           }
    assert { attrs[:age]        == 18                   }
    assert { attrs[:lose]       == 12                   }
    assert { attrs[:ox]         == "oxxoxxxoxxxxooxxxo" }
  end
end
