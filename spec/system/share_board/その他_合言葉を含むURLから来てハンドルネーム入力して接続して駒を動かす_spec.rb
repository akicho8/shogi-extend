require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    visit_app(room_key: :test_room)             # 合言葉を含むURLから来る
    assert_selector(".RoomSetupModal")          # 「入退室」のモーダルが自動的に表示されている
    Capybara.within(".RoomSetupModal") do
      assert_text("入退室")                 # 「入退室」のモーダルのタイトルも正しい
      find(".new_user_name input").set(:alice) # ハンドルネームを入力する
      find(".room_entry_button").click               # 入室ボタンをクリックする
      find(".close_handle").click               # 閉じる
    end
    assert_text(:alice)                        # 入力したハンドルネームの人がメンバーリストに表示されている
    piece_move_o("77", "76", "☗7六歩")
  end
end
