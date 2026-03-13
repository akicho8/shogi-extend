require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def case1
    visit_room({
        :user_name    => "a",
        :FIXED_MEMBER => "a,b",
        :FIXED_ORDER  => "a,b",
      })
    order_modal_open
    find(".tabs .order_tab_rule").click
    find(".is_foul_mode_takeback").click                      # 反則「ブロック」を選択する
    assert_selector(".ReformConductModal")             # 警告モーダルを表示する
    yield
    assert_no_selector(".ReformConductModal")          # 警告モーダルは閉じている
  end

  it "キャンセルする場合" do
    case1 do
      find(".ReformConductModal .cancel_handle").click # 「もちろん必要ない」
      assert_selector(".is_foul_mode_lose .is-selected")   # 反則「したら負け」に戻っている
    end
  end

  it "有効化する場合" do
    case1 do
      find(".ReformConductModal .submit_handle").click # 「接待する」
      assert_selector(".is_foul_mode_takeback .is-selected")  # 反則「ブロック」のままになっている
    end
  end
end
