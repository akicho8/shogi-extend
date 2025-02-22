require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    a_block do
      room_setup("test_room", "alice")    # aliceが部屋を作る
    end
    b_block do
      room_setup("test_room", "bob")      # bobも同じ入退室
    end
    b_block do
      place_click("27")                 # bobさんが手番を間違えて▲26歩しようとして27の歩を持ち上げた
    end
    a_block do
      piece_move_o("77", "76", "☗7六歩") # そのタイミングでaliceさんが▲76歩と指した
    end
    b_block do                          # bobさんの27クリックはキャンセルされた
      piece_move_o("33", "34", "☖3四歩") # bobが指す
      piece_move("88", "22")            # bobは2手指しで▲22角成をしようとして確認モーダルが表示されている
    end
    a_block do
      piece_move_o("27", "26", "☗2六歩") # そのタイミングでaliceさんが▲26歩と指してbobさんの2手指差未遂はキャンセルされた
    end
  end
end
