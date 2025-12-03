require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it do
    visit_app(body: "position startpos")
    find("a", text: "本譜", exact_text: true).click   # 本譜のリンクをクリック
    assert_selector(".ActionLogModal") # すると履歴と同じモーダルが出現する
  end
end
