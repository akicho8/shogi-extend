require "rails_helper"

RSpec.describe Admin::ScriptsController, type: :controller do
  include AdminSupport
  include WkbkSupportMethods
  include SwarsSupport

  it "ログイン必須になっている" do
    assert { Admin::ScriptsController.ancestors.include?(Admin::ApplicationController) }
  end

  it "認証していないのでエラーになる" do
    get :show, params: { id: "index" }
    assert { response.status == 401 }
  end

  describe "すべてのスクリプト" do
    BackendScript.bundle_scripts.each do |e|
      next if e == BackendScript::SidekiqConpaneScript
      it e.script_name do
        http_auth_login
        get :show, params: { id: e.key }
        assert { response.status == 200 }
      end
    end
  end
end
