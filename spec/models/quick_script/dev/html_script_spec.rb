require "rails_helper"

module QuickScript
  RSpec.describe Dev::HtmlScript, type: :model do
    it "works" do
      assert { Dev::HtmlScript.new.as_json }
    end
  end
end
