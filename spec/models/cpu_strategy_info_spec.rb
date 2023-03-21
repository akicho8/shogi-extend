require "rails_helper"

RSpec.describe CpuStrategyInfo, type: :model do
  it "score_table" do
    is_asserted_by { CpuStrategyInfo.values_without_all_round.all?(&:score_table) }
  end
end
