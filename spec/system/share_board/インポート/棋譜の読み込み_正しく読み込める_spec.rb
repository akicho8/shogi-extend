require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_app
    sidebar_open
    find(".kifu_loader_modal_open_handle").click                     # 「棋譜の読み込み」を開く
    find(".KifuLoaderModal textarea").set("68銀", clear: :backspace) # 入力
    find(".KifuLoaderModal .submit_handle").click                    # 読み込みボタンを押す
    assert_no_selector(".KifuLoaderModal")                           # 「棋譜の読み込み」のモーダルは消えている
    assert_no_selector(".SbControlPanel")                            # サイドバーも消えている (読み込んだあとでサイドバーで何かすることはないので閉じている)
    assert_turn(1)                                                   # 1手目になっている
  end
end
