module SharedMethods
  # alice と bob が同じ部屋で2手目まで進めた状態
  def setup_alice_bob_turn2
    a_block do
      room_setup("test_room", "alice", :room_restore_key => "skip")    # alice先輩が部屋を作る
    end
    b_block do
      room_setup("test_room", "bob", :room_restore_key => "skip")      # bob後輩が同じ入退室
    end
    a_block do
      piece_move_o("77", "76", "☗7六歩")  # aliceが指す
    end
    b_block do
      piece_move_o("33", "34", "☖3四歩")  # bobが指す
    end
    a_block do
      assert_turn(2)
    end
    b_block do
      assert_turn(2)
    end
  end
end
