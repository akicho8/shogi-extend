require "rails_helper"

RSpec.describe Api::SessionsController, type: :controller do
  before do
    @user = User.create!
    user_login(@user)
  end

  it "auth_user_fetch" do
    get :auth_user_fetch, params: {}
    is_asserted_by { response.status == 200 }
  end

  it "auth_user_logout" do
    post :auth_user_logout, params: {}
    is_asserted_by { response.status == 200 }
  end

  it "auth_user_destroy" do
    post :auth_user_destroy, params: {}
    is_asserted_by { response.status == 200 }
    is_asserted_by { User.where(id: @user.id).none? }
  end
end
