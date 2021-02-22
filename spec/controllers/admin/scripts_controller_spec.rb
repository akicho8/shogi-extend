require 'rails_helper'

RSpec.describe Admin::ScriptsController, type: :controller do
  include WkbkSupportMethods

  def login!
    request.env["HTTP_AUTHORIZATION"] = ActionController::HttpAuthentication::Basic.encode_credentials(SecureRandom.hex, Rails.application.credentials[:admin_password])
  end

  it "ログイン必須になっている" do
    assert { Admin::ScriptsController.ancestors.include?(Admin::ApplicationController) }
  end

  it "認証していないのでエラーになる" do
    get :show, params: { id: "index" }
    expect(response).to have_http_status(401)
  end

  describe "すべてのスクリプト" do
    BackendScript.bundle_scripts.each do |e|
      next if e == BackendScript::SidekiqConpaneScript
      it e.script_name do
        login!
        get :show, params: { id: e.key }
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
