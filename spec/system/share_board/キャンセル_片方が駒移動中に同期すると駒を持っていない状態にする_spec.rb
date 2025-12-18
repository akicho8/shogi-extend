require "#{__dir__}/sb_support_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    window_a do
      room_setup_by_user(:a)    # aが部屋を作る
    end
    window_b do
      room_setup_by_user(:b)      # bも同じ入退室
    end
    window_b do
      place_click("27")                 # bさんが手番を間違えて▲26歩しようとして27の歩を持ち上げた
    end
    window_a do
      piece_move_o("77", "76", "☗7六歩") # そのタイミングでaさんが▲76歩と指した
    end
    window_b do                          # bさんの27クリックはキャンセルされた
      piece_move_o("33", "34", "☖3四歩") # bが指す
      piece_move("88", "22")            # bは2手指しで▲22角成をしようとして確認モーダルが表示されている
    end
    window_a do
      piece_move_o("27", "26", "☗2六歩") # そのタイミングでaさんが▲26歩と指してbさんの2手指差未遂はキャンセルされた
    end
  end
end
