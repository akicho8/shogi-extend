require "rails_helper"

RSpec.describe QuickScript::Swars::GradeStatScript::PrimaryAggregator, type: :model do
  it "works" do
    QuickScript::Swars::GradeStatScript::PrimaryAggregator.mock_setup
    assert { QuickScript::Swars::GradeStatScript::PrimaryAggregator.new.call[:total_user_count] == 2 }
  end
end
