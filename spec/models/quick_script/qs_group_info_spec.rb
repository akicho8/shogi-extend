require "rails_helper"

module QuickScript
  RSpec.describe QsGroupInfo, type: :model do
    it "works" do
      assert { QsGroupInfo[:dev].link_path == "/bin/dev" }
      assert { QsGroupInfo[:dev].name == "*開発用*"      }
    end
  end
end
