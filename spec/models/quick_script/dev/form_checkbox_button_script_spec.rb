require "rails_helper"

RSpec.describe QuickScript::Dev::FormCheckboxButtonScript, type: :model do
  xit "works" do
    assert { QuickScript::Dev::FormCheckboxButtonScript.new(x: "__empty__").params[:x] == ""         }
    assert { QuickScript::Dev::FormCheckboxButtonScript.new(x: "[]").params[:x]        == []         }
    assert { QuickScript::Dev::FormCheckboxButtonScript.new(x: "[a]").params[:x]       == ["a"]      }
    assert { QuickScript::Dev::FormCheckboxButtonScript.new(x: "[a,b]").params[:x]     == ["a", "b"] }
  end
end
