require "rails_helper"

RSpec.describe QuickScript::Chore::MessageScript, type: :model do
  it "works" do
    html = QuickScript::Chore::MessageScript.new(message: "(message)", return_to: "(return_to)").call
    assert { html.include?("(message)") }
    assert { html.include?("(return_to)") }
  end
end
