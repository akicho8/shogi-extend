require "rails_helper"

RSpec.describe QuickScript::About::CreditScript, type: :model do
  it "works" do
    assert { QuickScript::About::CreditScript.new.as_json }
  end
end
