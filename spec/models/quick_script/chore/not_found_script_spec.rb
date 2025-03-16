require "rails_helper"

RSpec.describe QuickScript::Chore::NotFoundScript, type: :model do
  it "works" do
    assert { QuickScript::Chore::NotFoundScript.new.as_json }
  end
end
