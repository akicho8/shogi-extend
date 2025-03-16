require "rails_helper"

RSpec.describe QuickScript::About::TermsScript, type: :model do
  it "works" do
    assert { QuickScript::About::TermsScript.new.as_json }
  end
end
