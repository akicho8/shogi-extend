require 'rails_helper'

RSpec.describe Admin::HomesController, type: :controller do
  it "認証が必要" do
    get :show
    assert { response.status == 401 }
  end

  it "show" do
    request.env["HTTP_AUTHORIZATION"] = ActionController::HttpAuthentication::Basic.encode_credentials(SecureRandom.hex, Rails.application.credentials[:admin_password])
    get :show
    assert { response.status == 200 }
  end
end
