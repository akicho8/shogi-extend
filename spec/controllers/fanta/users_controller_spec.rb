require 'rails_helper'

RSpec.describe Fanta::UsersController, type: :controller do
  before do
    @current_user = user_login
  end

  it "show" do
    get :show, params: {id: @current_user.id}
    expect(response).to have_http_status(:ok)
  end

  it "edit" do
    get :edit, params: {id: @current_user.id}
    expect(response).to have_http_status(:ok)
  end

  it "update" do
    name = SecureRandom.hex
    put :update, params: {id: @current_user.id, fanta_user: {name: name, avatar: fixture_file_upload("spec/rails.png", "image/png")}}
    expect(response).to have_http_status(:redirect)
    @current_user.reload
    assert { @current_user.name == name }
    assert { @current_user.avatar.filename.to_s == "rails.png" }
  end
end
