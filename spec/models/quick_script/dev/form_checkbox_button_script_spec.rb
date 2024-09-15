require "rails_helper"

module QuickScript
  RSpec.describe Dev::FormCheckboxButtonScript, type: :model do
    it "works" do
      assert { Dev::FormCheckboxButtonScript.new(x: "a").params[:x]         == ["a"]      }
      assert { Dev::FormCheckboxButtonScript.new(x: "a,b").params[:x]       == ["a", "b"] }
      assert { Dev::FormCheckboxButtonScript.new(x: "a b").params[:x]       == ["a", "b"] }
      assert { Dev::FormCheckboxButtonScript.new(x: "__empty__").params[:x] == []         }
    end
  end
end
