require "rails_helper"

module QuickScript
  RSpec.describe Chore::MessageScript, type: :model do
    it "works" do
      html = Chore::MessageScript.new(message: "(message)", return_to: "(return_to)").call
      assert { html.include?("(message)") }
      assert { html.include?("(return_to)") }
    end
  end
end
