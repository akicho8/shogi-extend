require "rails_helper"

RSpec.describe QuickScript::Swars::GradeAggregator, type: :model do
  it "works" do
    res = QuickScript::Swars::GradeAggregator.sample
    assert { res[:user][:plain_counts]                == {:"九段" => 1, :"初段" => 2} }
    assert { res[:user][:tag_counts][:"GAVA角"]       == {:"九段" => 1 } }
    assert { res[:membership][:plain_counts]          == {:"九段" => 2, :"初段" => 2} }
    assert { res[:membership][:tag_counts][:"GAVA角"] == {:"九段" => 2} }
  end
end
