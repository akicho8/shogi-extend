require "rails_helper"

module QuickScript
  RSpec.describe Dev::FormCheckboxButtonScript, type: :model do
    it "works" do
      assert { Dev::FormCheckboxButtonScript.new(x: "[]").params[:x]    == []         }
      assert { Dev::FormCheckboxButtonScript.new(x: "[a]").params[:x]   == ["a"]      }
      assert { Dev::FormCheckboxButtonScript.new(x: "[a,b]").params[:x] == ["a", "b"] }
    end
  end
end
