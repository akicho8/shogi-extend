require "rails_helper"

RSpec.describe QuickScript::Swars::GradeAggregator, type: :model do
  it "works" do
    QuickScript::Swars::GradeAggregator.mock_setup
    QuickScript::Swars::GradeAggregator.new.cache_write

    res = QuickScript::Swars::GradeAggregator.new.aggregate
    assert { res[:user][:plain_counts]                == { :"九段" => 1, :"初段" => 2 } }
    assert { res[:user][:tag_counts][:"GAVA角"]       == { :"九段" => 1 } }
    assert { res[:membership][:plain_counts]          == { :"九段" => 2, :"初段" => 2 } }
    assert { res[:membership][:tag_counts][:"GAVA角"] == { :"九段" => 2 } }
  end
end
