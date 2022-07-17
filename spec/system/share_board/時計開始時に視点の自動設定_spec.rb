require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  def case1(preset_key)
    a_block do
      room_setup("my_room", "alice") # aliceが部屋を作る
    end
    b_block do
      room_setup("my_room", "bob")   # bobも同じ部屋に入る
    end
    a_block do
      preset_select(preset_key)      # 手合割設定
      order_set_on                   # 順番設定ON
      clock_start                    # 対局時計PLAY
    end
  end

  it "平手" do
    case1("平手")
    a_block do
      assert_viewpoint(:black) # bob が▲なので盤が反転していない
    end
    b_block do
      assert_viewpoint(:white) # alice が△なので盤が反転している
    end
  end

  it "駒落ち" do
    case1("八枚落ち")
    a_block do
      assert_viewpoint(:white) # bob が△なので盤が反転している
    end
    b_block do
      assert_viewpoint(:black) # alice が▲なので盤が反転している
    end
  end
end
