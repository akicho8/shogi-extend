require "rails_helper"

RSpec.describe QuickScript::Swars::SearchDefaultScript, type: :model do
  it "works" do
    assert { QuickScript::Swars::SearchDefaultScript.new.as_json }
    assert { QuickScript::Swars::SearchDefaultScript.new({ swars_search_default_key: "alice" }, { _method: "post" }).as_json[:flash][:notice] == "記憶しました" }
    assert { QuickScript::Swars::SearchDefaultScript.new({ swars_search_default_key: "" }, { _method: "post" }).as_json[:flash][:notice]      == "忘れました"   }
  end
end
