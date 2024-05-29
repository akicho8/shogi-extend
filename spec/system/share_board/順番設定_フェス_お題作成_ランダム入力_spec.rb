require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  def case1(user_name)
    visit_app({
        :room_key            => :test_room,
        :user_name            => user_name,
        :fixed_member_names   => "a",
        :handle_name_validate => "false",
      })
  end

  it "works" do
    a_block { case1("a") }
    a_block do
      global_menu_open
      os_modal_handle                                         # 「順番設定」モーダルを開く
      os_switch_toggle                                        # 有効スイッチをクリック
      find(:button, text: "お題ﾒｰｶｰ", exact_text: true).click # お題メーカー起動

      # 未入力
      within(".odai_subject") { assert_selector(:fillable_field, with: "") }
      within(".odai_left")    { assert_selector(:fillable_field, with: "") }
      within(".odai_right")   { assert_selector(:fillable_field, with: "") }

      find(".odai_src_random_handle").click # ランダム入力

      # 入力がある
      within(".odai_subject") { assert_selector(:fillable_field, with: /.+/) }
      within(".odai_left")    { assert_selector(:fillable_field, with: /.+/) }
      within(".odai_right")   { assert_selector(:fillable_field, with: /.+/) }
    end
  end
end
