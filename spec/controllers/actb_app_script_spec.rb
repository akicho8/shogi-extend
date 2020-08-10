require 'rails_helper'

RSpec.describe ScriptsController, type: :controller do
  describe "ActbAppScript" do
    include ActbSupportMethods

    before do
      user_login
    end

    describe "プロフィールの更新" do
      it do
        put :update, params: { id: "actb-app", remote_action: "profile_update", name: "(user_name1)", profile_description: "a" * (512 + 1) }
        expect(response).to have_http_status(:ok)
        retv = JSON.parse(response.body)
        assert { retv["error_message"] }
      end
    end

    describe "マッチング開始通知にロビーにいる人が気づいて挑戦を受け入れた" do
      def test1
        params = {
          session_lock_token: SecureRandom.hex,
          rule_key: :marathon_rule,
          user_id: user1.id,
        }

        put :update, params: { id: "actb-app", remote_action: "new_challenge_accept_handle", **params}
        expect(response).to have_http_status(:ok)
        hash = JSON.parse(response.body)
        hash["status"]
      end

      it "相手がもういない" do
        assert { test1 == "opponent_missing" }
      end

      it "マッチングした" do
        Actb::Rule[:marathon_rule].matching_users_add(user1)
        assert { test1 == "success" }
      end
    end
  end
end
