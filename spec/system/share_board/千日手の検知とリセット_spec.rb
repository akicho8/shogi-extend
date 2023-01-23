require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  def black_king_move_up
    piece_move_o("59", "58", "☗5八玉")
  end
  def white_king_move_up
    piece_move_o("51", "52", "☖5二玉")
  end
  def black_king_move_down
    piece_move_o("58", "59", "☗5八玉")
  end
  def white_king_move_down
    piece_move_o("52", "51", "☖5一玉" )
  end
  def king_move_up
    black_king_move_up
    white_king_move_up
  end
  def king_move_down
    black_king_move_up
    white_king_move_up
  end
  def king_move_up_down
    king_move_up
    king_move_down
  end

  it "4回目の同一局面でモーダルが発動する" do
    visit_app
    king_move_up_down
    king_move_up_down
    king_move_up_down
    piece_move_o("59", "58", "☗5八玉")           # 4回目の同一局面でモーダルが発動する
    assert_selector(".SennichiteModal")          # モーダルが存在する
    find(".SennichiteModal .close_handle").click # 「閉じる」
    assert_no_selector(".SennichiteModal")       # モーダルが閉じた
  end

  it "スライダーで2手目から1手目に戻しただけで千日手情報をリセットする" do
    visit_app
    king_move_up_down
    assert_system_variable("sennichite_cop.count", 4)
    sp_controller_click("previous")
    assert_system_variable("sennichite_cop.count", 0)
  end

  it "入室時にリセットする" do
    a_block do
      visit_app
      king_move_up_down
      assert_system_variable("sennichite_cop.count", 4)
      room_menu_open_and_input("test_room", "alice") # 入室
      assert_system_variable("sennichite_cop.count", 0)
    end
  end

  it "退室時にリセットする" do
    a_block do
      room_setup("test_room", "alice")
      king_move_up_down
      assert_system_variable("sennichite_cop.count", 4)
      room_leave
      assert_system_variable("sennichite_cop.count", 0)
    end
  end

  it "同期したとき相手もリセットする" do
    a_block do
      room_setup("test_room", "alice")
    end
    b_block do
      room_setup("test_room", "bob")
    end
    a_block do

      room_setup("test_room", "alice")
      king_move_up_down
      assert_system_variable("sennichite_cop.count", 4)
      room_leave
      assert_system_variable("sennichite_cop.count", 0)
    end
  end
end
