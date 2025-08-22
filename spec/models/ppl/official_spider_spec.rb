require "rails_helper"

RSpec.describe Ppl::OfficialSpider, type: :model do
  it "works" do
    rows = Ppl::OfficialSpider.new(season_number: 66, take_size: 1, verbose: false, sleep: 0).call
    row = rows.sole
    assert { row[:result_key] == "維"                 }
    assert { row[:name]       == "古賀悠聖"           }
    assert { row[:age]        == 18                   }
    assert { row[:win]        == 6                    }
    assert { row[:lose]       == 12                   }
    assert { row[:ox]         == "oxxoxxxoxxxxooxxxo" }
  end
end
