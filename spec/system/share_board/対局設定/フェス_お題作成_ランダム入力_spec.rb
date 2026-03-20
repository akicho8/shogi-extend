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
      sidebar_open
      order_modal_open_handle
      order_switch_on                                        # 有効スイッチをクリック
      find(".tabs .order_tab_fes").click

      find(:button, text: "お題作成", exact_text: true).click # お題作成起動
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
