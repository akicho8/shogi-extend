require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "Aが対局時計操作中にCが入室したときBはCだけに時計情報を送るのでAの対局時計がBの内容で更新されない" do
    a_block do
      visit_app(room_code: :my_room, force_user_name: "alice")
    end
    b_block do
      visit_app(room_code: :my_room, force_user_name: "bob")
    end
    c_block do
      visit_app(room_code: :my_room, force_user_name: "carol")
      text_click "[入室時の情報要求]"
    end
    a_block do
      assert_no_text "alice は bob の時計情報を受信して反映した"
    end
  end
end
