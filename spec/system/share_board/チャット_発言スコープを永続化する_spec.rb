require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  # 部屋に入り直した際に発言スコープが ms_public に戻ったことに気づかないで発言する事例があったため永続化する
  it "works" do
    visit_room(user_name: :a, FIXED_ORDER: :a)
    chat_modal_open
    message_scope_key_set("ms_private")

    visit_room(user_name: :a, FIXED_ORDER: :a)
    chat_modal_open
    assert_message_scope_key("ms_private")
  end
end
