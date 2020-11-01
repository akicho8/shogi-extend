require 'rails_helper'

RSpec.describe Api::ActbController, type: :controller do
  include ActbSupportMethods

  before do
    @current_user = user_login
  end

  # describe "プロフィールの更新" do
  #   it "名前を入力してもらう" do
  #     @current_user.update!(name_input_at: nil)
  #     put :update, params: { remote_action: "user_profile_update", name: "(user_name1)" }
  #     expect(response).to have_http_status(:ok)
  #     @current_user.reload
  #     assert { @current_user.name_input_at }
  #   end
  #   it do
  #     @current_user.update!(name_input_at: nil)
  #
  #     put :update, params: { remote_action: "user_profile_update", name: "(user_name1)", profile_description: "a" * (512 + 1) }
  #     expect(response).to have_http_status(:ok)
  #     retv = JSON.parse(response.body)
  #     assert { retv["error_message"] }
  #   end
  # end

  describe "マッチング開始通知にロビーにいる人が気づいて挑戦を受け入れた" do
    def test1
      params = {
        session_lock_token: SecureRandom.hex,
        rule_key: :marathon_rule,
        user_id: user1.id,
      }

      put :update, params: { remote_action: "new_challenge_accept_handle", **params}
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

  describe "zip_dl_count_fetch" do
    it "works" do
      @current_user.actb_questions.create_mock1
      get :show, params: { remote_action: "zip_dl_count_fetch", format: "json" }
      expect(response).to have_http_status(:ok)
      assert { JSON.parse(response.body) == {"count" => 1} }
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .....
# >>
# >> Finished in 2.05 seconds (files took 2.33 seconds to load)
# >> 5 examples, 0 failures
# >>
