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

    describe "profile_update" do
      it do
        put :update, params: { id: "actb-app", remote_action: "profile_update", name: "(user_name1)", profile_description: "a" * (512 + 1) }
        expect(response).to have_http_status(:ok)
        retv = JSON.parse(response.body)
        assert { retv["error_message"] }
      end
    end

    describe "yarimasu_handle" do
      def test1
        put :update, params: { id: "actb-app", remote_action: "yarimasu_handle", session_lock_token: SecureRandom.hex }
        expect(response).to have_http_status(:ok)
        hash = JSON.parse(response.body)
        hash["status"]
      end

      it "相手がもういない" do
        assert { test1 == "not_have_any_opponent" }
      end

      it "マッチングした" do
        Actb::Rule[:sy_marathon].matching_users_add(user1)
        assert { test1 == "success" }
      end
    end
  end
end
