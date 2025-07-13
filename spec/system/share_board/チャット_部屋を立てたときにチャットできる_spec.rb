require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  let(:message1) { SecureRandom.hex }
  let(:message2) { SecureRandom.hex }

  it "メッセージが自分と相手に届く" do
    a_block do
      room_setup("test_room", "alice") # aliceが部屋を作る
    end
    b_block do
      room_setup("test_room", "bob") # bobも同じ入退室
    end
    a_block do
      find(".chat_modal_open_handle").click            # 開く
      chat_message_send(message1)
      assert_message_body(wait: 3)
      assert_message_received_o(message1, wait: 3)
    end
    b_block do
      find(".chat_modal_open_handle").click # 開く
      assert_message_received_o(message1) # bob にも届いた
    end
  end

  it "観戦者宛送信" do
    a_block { visit_app(room_key: :test_room, user_name: "alice", fixed_order_names: "alice", autoexec: "chat_modal_open_handle") }
    b_block { visit_app(room_key: :test_room, user_name: "bob",   fixed_order_names: "alice", autoexec: "chat_modal_open_handle") }
    c_block { visit_app(room_key: :test_room, user_name: "carol", fixed_order_names: "alice", autoexec: "chat_modal_open_handle") }

    b_block { scoped_message_send(:ms_private, message1) } # 観戦者の bob が観戦者送信した
    b_block { assert_message_received_o(message1)        } # 自分には (観戦者かに関係なく本人だから) 届いている
    a_block { assert_message_received_x(message1)        } # alice には対局者なので届いていない
    c_block { assert_message_received_o(message1)        } # carol には観戦者なので届いている

    a_block { scoped_message_send(:ms_private, message2) } # 対局者の alice が送信した
    a_block { assert_message_received_o(message2)        } # 自分には (観戦者かに関係なく本人だから) 届いている
    b_block { assert_message_received_o(message2)        } # bob   には観戦者なので届いている
    c_block { assert_message_received_o(message2)        } # carol には観戦者なので届いている

    b_block do
      chat_modal_close
      order_set_off             # 順番設定を解除する
    end

    # bobが順番設定を解除したことで
    a_block do
      assert_message_received_o(message1)                      # bob の送信を alice は見えるようになった
      assert_no_selector(".ChatModal .message_scope_dropdown") # 順番設定を解除したためスコープ選択は表示されていない
    end
  end

  it "順番設定していたら観戦者がいなくてもスコープ選択ドロップダウンが出ている" do
    visit_app(room_key: :test_room, user_name: "alice", fixed_order_names: "alice", autoexec: "chat_modal_open_handle")
    assert_selector(".ChatModal .message_scope_dropdown")
  end

  it "Enterで送信できる" do
    visit_app(room_key: :test_room, user_name: "alice", autoexec: "chat_modal_open_handle")
    within(".ChatModal") do
      find(:fillable_field).set(message1)
      find(:fillable_field).send_keys("\n")
    end
    assert_message_received_o(message1)
  end
end
