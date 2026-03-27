require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_app
    sidebar_open
    find(".kifu_loader_modal_open_handle").click # 「棋譜の読み込み」を開く
    find(".KifuLoaderModal textarea").set("58金", clear: :backspace) # 入力
    find(".KifuLoaderModal .submit_handle").click                    # 読み込みボタンを押す
    assert_selector(".BioshogiErrorModal")                           # 不整合のモーダルが出ている
    find(".BioshogiErrorModal .close_handle").click                  # 不整合のモーダルを閉じる
    assert_no_selector(".BioshogiErrorModal")                        # 閉じることができている
    assert_selector(".KifuLoaderModal")                              # 「棋譜の読み込み」のモーダルはそのまま生きている
    assert_selector(".SbControlPanel")                               # サイドバーも生きている
  end
end
