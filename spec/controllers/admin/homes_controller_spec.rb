require "rails_helper"

RSpec.describe Admin::HomesController, type: :controller do
  include AdminSupport

  it "認証が必要" do
    get :show
    assert { response.status == 401 }
  end

  it "show" do
    http_auth_login
    get :show
    assert { response.status == 200 }
  end
end
