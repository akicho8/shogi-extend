require "rails_helper"

RSpec.describe Ppl::MedievalSpider, type: :model do
  it "works" do
    rows = Ppl::MedievalSpider.new(season_key_vo: Ppl::SeasonKeyVo["1"], take_size: 1, verbose: false, sleep: 0, promotion_count_gteq: 0).call
    row = rows.sole
    assert { row[:result_key] == "維"               }
    assert { row[:name]       == "村松央一"         }
    assert { row[:age]        == 28                 }
    assert { row[:win]        == 7                  }
    assert { row[:lose]       == 9                  }
    assert { row[:ox]         == "xxxooxoooooxxxxx" }
  end
end
