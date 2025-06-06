require "rails_helper"

RSpec.describe Tsl::Scraping, type: :model do
  let :scraping do
    Tsl::Scraping.new(generation: 66)
  end

  it "works" do
    assert { scraping.user_infos.count == 30 }
    assert { scraping.user_infos.first == { result_key: "none", start_pos: 1, name: "古賀悠聖", parent: "中田功", age: 18, win: 6, lose: 12, ox: "oxxoxxxoxxxxooxxxo" } }
  end
end
