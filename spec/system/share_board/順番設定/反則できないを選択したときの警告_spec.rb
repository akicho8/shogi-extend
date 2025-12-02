require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def case1
    visit_room({
        :user_name    => "a",
        :FIXED_MEMBER => "a,b",
        :FIXED_ORDER  => "a,b",
      })
    os_modal_open
    find(".is_foul_mode_block").click                      # 反則「できない」を選択する
    assert_selector(".FoulModeBlockWarnModal")             # 警告モーダルを表示する
    yield
    assert_no_selector(".FoulModeBlockWarnModal")          # 警告モーダルは閉じている
  end

  it "キャンセルする場合" do
    case1 do
      find(".FoulModeBlockWarnModal .cancel_handle").click # 「もちろん必要ない」
      assert_selector(".is_foul_mode_lose .is-selected")   # 反則「したら負け」に戻っている
    end
  end

  it "有効化する場合" do
    case1 do
      find(".FoulModeBlockWarnModal .submit_handle").click # 「接待する」
      assert_selector(".is_foul_mode_block .is-selected")  # 反則「できない」のままになっている
    end
  end
end
