require "#{__dir__}/helper"

RSpec.describe type: :system, share_board_spec: true do
  it do
    visit_app(body: "position startpos")
    find("a", text: "本譜", exact_text: true).click   # 本譜のリンクをクリック
    assert_selector(".ActionLogModal") # すると履歴と同じモーダルが出現する
  end
end
