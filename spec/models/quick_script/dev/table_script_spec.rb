require "rails_helper"

module QuickScript
  RSpec.describe Dev::TableScript, type: :model do
    it "works" do
      assert { Dev::TableScript.new.as_json }
    end
  end
end
