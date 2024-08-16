require "rails_helper"

module QuickScript
  RSpec.describe Swars::SearchDefaultScript, type: :model do
    it "works" do
      assert { Swars::SearchDefaultScript.new.as_json }
      assert { Swars::SearchDefaultScript.new({swars_search_default_key: "alice"}, {_method: "post"}).as_json[:flash][:notice] == "記憶しました" }
      assert { Swars::SearchDefaultScript.new({swars_search_default_key: ""}, {_method: "post"}).as_json[:flash][:notice]      == "忘れました"   }
    end
  end
end
