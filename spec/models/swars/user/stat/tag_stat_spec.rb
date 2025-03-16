require "rails_helper"

RSpec.describe Swars::User::Stat::TagStat, type: :model, swars_spec: true do
  def case1(strike_plan)
    @black = Swars::User.create!
    Swars::Battle.create!(strike_plan: strike_plan) do |e|
      e.memberships.build(user: @black)
    end
  end

  before do
    case1("棒銀")
  end

  it "to_chart" do
    assert do
      @black.stat.tag_stat.to_pie_chart([:"居飛車", :"振り飛車"]) == [
        { :name => :"居飛車",   :value => 1, },
        { :name => :"振り飛車", :value => 0, },
      ]
    end
  end

  it "counts_hash" do
    assert { @black.stat.tag_stat.counts_hash[:"棒銀"] }
  end

  it "ratios_hash" do
    assert { @black.stat.tag_stat.ratios_hash[:"棒銀"] == 1.0 }
  end

  it "to_win_lose_h" do
    assert { @black.stat.tag_stat.to_win_lose_h(:"棒銀") == { win: 1, lose: 0 } }
  end

  it "use_rate_for" do
    assert { @black.stat.tag_stat.use_rate_for(:"居飛車") == 1.0 }
    assert { @black.stat.tag_stat.use_rate_for(:"振り飛車") == 0.0 }
  end
end
