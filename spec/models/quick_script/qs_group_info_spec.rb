require "rails_helper"

RSpec.describe QuickScript::QsGroupInfo, type: :model do
  it "works" do
    assert { QuickScript::QsGroupInfo[:dev].qs_path == "/lab/dev" }
    assert { QuickScript::QsGroupInfo[:dev].name == "*開発用*"      }
  end
end
