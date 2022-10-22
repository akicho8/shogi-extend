require "rails_helper"

RSpec.describe Api::SessionsController, type: :controller do
  before do
    @user = User.create!
    user_login(@user)
  end

  it "auth_user_fetch" do
    get :auth_user_fetch, params: {}
    assert { response.status == 200 }
  end

  it "auth_user_logout" do
    post :auth_user_logout, params: {}
    assert { response.status == 200 }
  end

  it "auth_user_destroy" do
    post :auth_user_destroy, params: {}
    assert { response.status == 200 }
    assert { User.where(id: @user.id).none? }
  end
end
