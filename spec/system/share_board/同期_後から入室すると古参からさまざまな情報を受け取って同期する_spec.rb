require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  describe "盤面" do
    it "最大2手まである棋譜の1手目を指している部屋に入ったとき1手目になる" do
      a_block do
        visit_room(room_key: :test_room, user_name: "alice", body: "76歩34歩")
        sp_controller_click(:previous)      # 最長2手まである棋譜の1手目に戻す
        assert_turn(1)                      # 0手目に戻っている
        sleep(2)                            # 1秒後に転送するためそれが切れるまで待つ
      end
      b_block do
        visit_room(room_key: :test_room, user_name: "bob")
        assert_turn(1)                      # あとから来た bob は2手目ではなく1手目の局面になっている
      end
    end
  end
  describe "順番設定" do
    it "works" do
      a_block do
        visit_room(room_key: :test_room, user_name: "alice", fixed_order_names: "alice,bob")
        assert_text("order_enable_p:true")
      end
      b_block do
        visit_room(room_key: :test_room, user_name: "bob")
        assert_text("order_enable_p:true")
      end
    end
  end
  describe "時計" do
    it "works" do
      a_block do
        visit_room(room_key: :test_room, user_name: "alice")
        clock_open
        cc_modal_close
        assert_text("clock_box:true")
      end
      b_block do
        visit_room(room_key: :test_room, user_name: "bob")
        assert_text("clock_box:true")
      end
    end
  end
  describe "タイトル" do
    it "works" do
      a_block do
        visit_room(room_key: :test_room, user_name: "alice", title: "(new_title)")
      end
      b_block do
        visit_room(room_key: :test_room, user_name: "bob")
        assert_text("(new_title)")
      end
    end
  end
end
