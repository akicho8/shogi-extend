require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    window_a do
      visit_room({
          :user_name          => "a",
          :fixed_member => "a",
        })
    end
    window_a do
      os_modal_open
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
