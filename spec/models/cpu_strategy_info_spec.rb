require "rails_helper"

RSpec.describe CpuStrategyInfo, type: :model do
  it "score_table" do
    assert { CpuStrategyInfo.values_without_all_round.all?(&:score_table) }
  end
end
