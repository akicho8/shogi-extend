require "rails_helper"

module QuickScript
  module Account
    RSpec.describe ProfileImageUploadScript, type: :model do
      it "works" do
        user = User.create!
        params = { avatar: { data_uri: MiniImage.generate } }
        json = ProfileImageUploadScript.new(params, {current_user: user, _method: :post}).as_json
        assert { json[:redirect_to] }
      end
    end
  end
end
