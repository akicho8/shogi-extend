require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it do
    visit_app(body: "position startpos")
    find(".honpu_modal_open_handle").click     # 本譜のリンクをクリック
    assert_selector(".TimeMachineModal") # すると履歴と同じモーダルが出現する
  end
end
