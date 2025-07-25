require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    visit_app(auto_close_p: true) # 自動的に閉じるモード (production では true にしている)
    clock_open                    # 対局時計を開いて
    clock_play_button_click       # 開始する (このとき自動的に閉じる。インスタンスを null に設定する)
    global_menu_open              # 再度メニューから
    cc_modal_open_handle          # 対局時計を開くことができる
    find(".pause_button").click   # 一時停止する
    find(".resume_button").click  # 再開する (このとき自動的に閉じる。インスタンスを null に設定する)
    global_menu_open              # 再度メニューから
    cc_modal_open_handle          # 対局時計を開くことができる
  end
end
