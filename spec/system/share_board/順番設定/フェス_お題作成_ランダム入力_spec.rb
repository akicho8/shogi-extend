require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    window_a do
      visit_room({
          :user_name          => "a",
          :FIXED_MEMBER => "a",
        })
    end
    window_a do
      order_modal_open
      os_switch_toggle                                        # 有効スイッチをクリック
      find(:button, text: "お題ﾒｰｶｰ", exact_text: true).click # お題メーカー起動

      # 未入力
      within(".quiz_subject") { assert_selector(:fillable_field, with: "") }
      within(".quiz_left")    { assert_selector(:fillable_field, with: "") }
      within(".quiz_right")   { assert_selector(:fillable_field, with: "") }

      find(".quiz_source_random_handle").click # ランダム入力

      # 入力がある
      within(".quiz_subject") { assert_selector(:fillable_field, with: /.+/) }
      within(".quiz_left")    { assert_selector(:fillable_field, with: /.+/) }
      within(".quiz_right")   { assert_selector(:fillable_field, with: /.+/) }
    end
  end
end
