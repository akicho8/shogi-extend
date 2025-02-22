require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    a_block do
      visit_app(body: Bioshogi::SFEN1)                   # 盤面情報をつけてくると本譜ができる
      room_menu_open_and_input("test_room", "alice")     # 入退室
    end
    b_block do
      visit_app(room_key: :test_room, user_name: "bob") # bobが入室すると
      assert_honpu_link_on                            # 本譜が共有されている
    end
  end
end
