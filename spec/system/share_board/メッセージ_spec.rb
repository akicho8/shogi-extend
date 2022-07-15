require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    message1 = SecureRandom.hex
    a_block do
      room_setup("my_room", "alice")                   # aliceが部屋を作る
    end
    b_block do
      room_setup("my_room", "bob")                     # bobも同じ部屋に入る
    end
    a_block do
      find(".message_modal_handle").click              # aliceがメッセージモーダルを開く
      find(".MessageSendModal input").set(message1)    # メッセージ入力
      find(".MessageSendModal .send_handle").click     # 送信
      assert_text(message1)                            # 自分自身にメッセージが届く
    end
    b_block do
      assert_text(message1)                           # bobにもメッセージが届く
    end
  end

  it "観戦者宛送信" do
    a_block { visit_app(room_code: :my_room, force_user_name: "alice", ordered_member_names: "alice", autoexec: "message_modal_handle") }
    b_block { visit_app(room_code: :my_room, force_user_name: "bob",   ordered_member_names: "alice", autoexec: "message_modal_handle") }
    c_block { visit_app(room_code: :my_room, force_user_name: "carol", ordered_member_names: "alice", autoexec: "message_modal_handle") }

    message1 = SecureRandom.hex
    b_block { message_send(:is_message_scope_private, message1) }   # 観戦者の bob が観戦者送信した
    b_block { assert_text(message1)              }   # 自分には (観戦者かに関係なく本人だから) 届いている
    a_block { assert_no_text(message1)           }   # alice には対局者なので届いていない
    c_block { assert_text(message1)              }   # carol には観戦者なので届いている

    message2 = SecureRandom.hex
    a_block { message_send(:is_message_scope_private, message2) }   # 対局者の alice が送信した
    a_block { assert_text(message2)              }   # 自分には (観戦者かに関係なく本人だから) 届いている
    b_block { assert_text(message2)              }   # bob   には観戦者なので届いている
    c_block { assert_text(message2)              }   # carol には観戦者なので届いている

    b_block do
      find(".MessageSendModal .close_handle").click  # メッセージモーダルを閉じる
      order_set_off          # 順番設定を解除する
    end

    # bobが順番設定を解除したことで
    a_block do
      assert_text(message1)                                         # bob の送信を alice は見えるようになった
      assert_no_selector(".MessageSendModal .message_scope_dropdown") # 順番設定を解除したためスコープ選択は表示されていない
    end
  end

  it "順番設定していたら観戦者がいなくてもスコープ選択ドロップダウンが出ている" do
    a_block do
      visit_app(room_code: :my_room, force_user_name: "alice", ordered_member_names: "alice", autoexec: "message_modal_handle")
      assert_selector(".MessageSendModal .message_scope_dropdown")
    end
  end

  it "Enterで送信する" do
    a_block do
      visit_app(room_code: :my_room, force_user_name: "alice", ordered_member_names: "alice", autoexec: "message_modal_handle")
      message1 = SecureRandom.hex
      find(".MessageSendModal input").set(message1)
      find(".MessageSendModal input").send_keys("\n") # ENTER
      assert_text(message1)
    end
  end
end
