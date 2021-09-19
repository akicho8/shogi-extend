require 'rails_helper'

RSpec.describe Api::XmoviesController, type: :controller do
  include XmovieSupport

  before do
    @user1 = user_login
  end

  it "latest_info_reload" do
    post :latest_info_reload, params: {}.as_json, as: :json
    assert { response.status == 200 }
  end

  it "record_create" do
    post :record_create, params: params1.as_json, as: :json
    assert { response.status == 200 }
  end

  it "zombie_kill" do
    post :zombie_kill, params: {}.as_json, as: :json
    assert { response.status == 200 }
  end
end
