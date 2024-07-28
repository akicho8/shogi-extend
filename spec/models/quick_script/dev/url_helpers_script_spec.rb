require "rails_helper"

module QuickScript
  RSpec.describe Dev::UrlHelpersScript, type: :model do
    it "works" do
      assert { Dev::UrlHelpersScript.new.call }
    end
  end
end
