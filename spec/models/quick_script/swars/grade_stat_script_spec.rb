require "rails_helper"

RSpec.describe QuickScript::Swars::GradeStatScript, type: :model do
  def case1(params)
    instance = QuickScript::Swars::GradeStatScript.new(params)
    instance.as_json
    instance.total_count
  end

  it "works" do
    QuickScript::Swars::GradeStatScript::PrimaryAggregator.mock_setup
    QuickScript::Swars::GradeStatScript.primary_aggregate_call

    assert { case1({}) == 2 }
    assert { case1(tag: "居飛車") == 2 }
    assert { case1(tag: "オザワシステム") == 0 }
  end
end
