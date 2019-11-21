require 'rails_helper'

RSpec.describe CpuStrategyInfo, type: :model do
  it "score_table" do
    assert { CpuStrategyInfo["アヒル戦法"].score_table }
  end
end
