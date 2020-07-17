require 'rails_helper'

RSpec.describe ScriptsController, type: :controller do
  before do
    Swars.setup
  end

  describe "すべてのスクリプト" do
    FrontendScript.bundle_scripts.each do |e|
      it e.script_name do
        get :show, params: { id: e.key }
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "attack-rarity (json対応)" do
    before do
      get :show, params: { id: "attack-histogram", format: "json" }
    end
    let :value do
      JSON.parse(response.body)
    end
    it "json" do
      assert { value.find { |e| e["name"] == "嬉野流" } }
    end
  end

  describe "ActbAppScript" do
    include ActbSupportMethods
    before do
      user_login
    end
    it do
      put :update, params: { id: "actb-app", remote_action: "profile_update", user_name: "(user_name1)", user_description: "a" * 1024 }
      retv = JSON.parse(response.body)
      assert { retv["error_message"] }
      expect(response).to have_http_status(:ok)
    end
  end
end
