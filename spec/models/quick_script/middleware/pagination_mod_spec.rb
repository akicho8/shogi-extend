require "rails_helper"

RSpec.describe QuickScript::Middleware::PaginationMod, type: :model do
  it "works" do
    User.create!
    object = QuickScript::Dev::NullScript.new(page: 1, per_page: 2)
    response = object.pagination_for(User.all)
    assert { response[:_component] == "QuickScriptViewValueAsTable" }
    value = response[:_v_bind][:value]
    assert { value[:rows].size >= 1 }
    assert { value[:paginated] == true }
    assert { value[:total] >= 1 }
    assert { value[:current_page] == 1 }
    assert { value[:per_page] == 2 }
    assert { value[:always_table] == false }
    assert { value[:header_hide] == false }
  end
end
