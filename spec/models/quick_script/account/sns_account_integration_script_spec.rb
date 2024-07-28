require "rails_helper"

module QuickScript
  module Account
    RSpec.describe SnsAccountIntegrationScript, type: :model do
      it "works" do
        user = User.create!
        json = SnsAccountIntegrationScript.new({}, {current_user: user}).as_json
        assert { json[:redirect_to] }
      end
    end
  end
end
