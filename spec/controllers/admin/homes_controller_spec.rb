require "rails_helper"

RSpec.describe Admin::HomesController, type: :controller do
  include AdminSupport

  it "BASIC認証が出て入れない" do
    get :show
    is_asserted_by { response.status == 401 }
  end

  it "BASIC認証を通したので入れる" do
    http_auth_login
    get :show
    is_asserted_by { response.status == 200 }
  end
end
