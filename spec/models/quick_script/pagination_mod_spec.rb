require "rails_helper"

module QuickScript
  RSpec.describe PaginationMod, type: :model do
    it "works" do
      User.create!
      object = Dev::NullScript.new(page: 1, per_page: 2)
      response = object.pagination_for(User.all)
      assert { response[:_component] == "QuickScriptViewValueAsTable" }
      assert { response[:rows].size >= 1 }
      assert { response[:paginated] == true }
      assert { response[:total] >= 1 }
      assert { response[:current_page] == 1 }
      assert { response[:per_page] == 2 }
      assert { response[:always_table] == false }
      assert { response[:header_hide] == false }
    end
  end
end
