require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    a_block do
      visit_app(body: Bioshogi::SFEN1)                   # 盤面情報をつけてくると本譜ができる
      room_menu_open_and_input("test_room", "alice")     # 部屋に入る
    end
    b_block do
      visit_app(room_code: :test_room, user_name: "bob") # bobが部屋に入ると
      assert_honpu_link_exist                            # 本譜が共有されている
    end
  end
end
