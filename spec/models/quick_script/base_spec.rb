require "rails_helper"

module QuickScript
  RSpec.describe Base, type: :model do
    it "works" do
      assert { Dev::NullScript.qs_group_key == "dev"  }
      assert { Dev::NullScript.qs_page_key  == "null" }
    end
  end
end
