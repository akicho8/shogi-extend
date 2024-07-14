require "rails_helper"

module QuickScript
  RSpec.describe Admin::SwarsAgentScript, type: :model do
    it "works" do
      assert { Admin::SwarsAgentScript.new.call }
    end
  end
end
