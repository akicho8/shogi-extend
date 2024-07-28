require "rails_helper"

module QuickScript
  module Account
    RSpec.describe InfoScript, type: :model do
      it "works" do
        assert { InfoScript.new({}, {current_user: User.create!}).as_json }
      end
    end
  end
end
