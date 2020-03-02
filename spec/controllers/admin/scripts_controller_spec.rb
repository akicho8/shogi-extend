require 'rails_helper'

RSpec.describe Admin::ScriptsController, type: :controller do
  it "ログイン必須になっている" do
    assert { Admin::ScriptsController.ancestors.include?(Admin::ApplicationController) }
  end

  it "認証していないのでエラーになる" do
    get :show, params: { id: "index" }
    expect(response).to have_http_status(401)
  end

  describe "すべてのスクリプト" do
    Admin::BackendScript.bundle_scripts.each do |e|
      it e.script_name do
        request.env["HTTP_AUTHORIZATION"] = ActionController::HttpAuthentication::Basic.encode_credentials(SecureRandom.hex, Rails.application.credentials[:admin_password])
        get :show, params: { id: e.key }
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
