require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  # 部屋に入り直した際に発言スコープが ms_public に戻ったことに気づかないで発言する事例があったため永続化する
  it "works" do
    visit_room(room_key: :test_room, user_name: "alice", fixed_order_names: "alice", autoexec: "chat_modal_open_handle")
    message_scope_key_set("ms_private")

    visit_room(room_key: :test_room, user_name: "alice", fixed_order_names: "alice", autoexec: "chat_modal_open_handle")
    assert_message_scope_key("ms_private")
  end
end
