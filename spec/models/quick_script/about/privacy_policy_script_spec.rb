require "rails_helper"

module QuickScript
  module About
    RSpec.describe PrivacyPolicyScript, type: :model do
      it "works" do
        assert { PrivacyPolicyScript.new.as_json }
      end
    end
  end
end
