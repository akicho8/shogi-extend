require "rails_helper"

module QuickScript
  RSpec.describe QsGroupInfo, type: :model do
    it "works" do
      assert { QsGroupInfo[:dev].qs_path == "/lab/dev" }
      assert { QsGroupInfo[:dev].name == "*開発用*"      }
    end
  end
end
