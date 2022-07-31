require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    a_block do
      room_setup("my_room", "alice")                    # alice先輩が部屋を作る
      assert_member_list(1, "is_joined", "alice")       # 一番上にaliceがいる
      sleep(2)                                          # 先輩後輩は最低1秒毎の差なので2秒待てば確実にbobは後輩になる
    end
    b_block do
      room_setup("my_room", "bob")                      # bob後輩が同じ部屋に入る
      assert_member_list(2, "is_joined", "bob")         # 最後に追加される
      sleep(2)                                          # これでbobをレベル2ぐらいにはなる(aliceはレベル4)
    end
    b_block do
      piece_move_o("77", "76", "☗7六歩")                # aliceが指してbobの盤も同じになる
      sp_controller_click("first")                      # 再起動時にbobから受けとったか確認しやすいように0手目にしておく
      assert_turn(0)
    end
    a_block do
      room_recreate_apply                               # 再起動実行
      assert_turn(0)                                    # bobから0手目をもらった
      assert_member_list(1, "is_joined", "bob")         # 並びは後輩だったbobが先輩に
      assert_member_list(2, "is_joined", "alice")       # 先輩だったaliceは後輩になっている
    end
  end
end
