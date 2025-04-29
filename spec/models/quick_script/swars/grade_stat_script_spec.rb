require "rails_helper"

RSpec.describe QuickScript::Swars::GradeStatScript, type: :model do
  def case1(params)
    instance = QuickScript::Swars::GradeStatScript.new(params)
    instance.as_json
    instance.status
  end

  it "works" do
    QuickScript::Swars::GradeAggregator.sample
    assert { case1({}) == { "人数合計" => 3, "対局数合計" => 4 } }
    assert { case1({ tag: "GAVA角" }) == { "人数合計" => 1, "対局数合計" => 2 } }
  end
end
