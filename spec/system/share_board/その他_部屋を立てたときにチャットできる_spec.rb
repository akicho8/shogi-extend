require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  let(:message1) { SecureRandom.hex }
  let(:message2) { SecureRandom.hex }

  it "メッセージが自分と相手に届く" do
    a_block do
      room_setup("my_room", "alice") # aliceが部屋を作る
    end
    b_block do
      room_setup("my_room", "bob") # bobも同じ部屋に入る
    end
    a_block do
      find(".message_modal_handle").click            # 開く
      within(".MessageSendModal") do
        find(:fillable_field).set(message1)          # メッセージ入力
        find(:button, :class => "send_handle").click # 送信
      end
      assert_message_received_o(message1)
    end
    b_block do
      find(".message_modal_handle").click # 開く
      assert_message_received_o(message1) # bob にも届いた
    end
  end

  it "観戦者宛送信" do
    a_block { visit_app(room_code: :my_room, fixed_user_name: "alice", fixed_order_names: "alice", autoexec: "message_modal_handle") }
    b_block { visit_app(room_code: :my_room, fixed_user_name: "bob",   fixed_order_names: "alice", autoexec: "message_modal_handle") }
    c_block { visit_app(room_code: :my_room, fixed_user_name: "carol", fixed_order_names: "alice", autoexec: "message_modal_handle") }

    b_block { scoped_message_send(:is_message_scope_private, message1) } # 観戦者の bob が観戦者送信した
    b_block { assert_message_received_o(message1) } # 自分には (観戦者かに関係なく本人だから) 届いている
    a_block { assert_message_received_x(message1) } # alice には対局者なので届いていない
    c_block { assert_message_received_o(message1) } # carol には観戦者なので届いている

    a_block { scoped_message_send(:is_message_scope_private, message2) } # 対局者の alice が送信した
    a_block { assert_message_received_o(message2) } # 自分には (観戦者かに関係なく本人だから) 届いている
    b_block { assert_message_received_o(message2) } # bob   には観戦者なので届いている
    c_block { assert_message_received_o(message2) } # carol には観戦者なので届いている

    b_block do
      find(".MessageSendModal .close_handle").click # メッセージモーダルを閉じる
      order_set_off             # 順番設定を解除する
    end

    # bobが順番設定を解除したことで
    a_block do
      assert_message_received_o(message1)                             # bob の送信を alice は見えるようになった
      assert_no_selector(".MessageSendModal .message_scope_dropdown") # 順番設定を解除したためスコープ選択は表示されていない
    end
  end

  it "順番設定していたら観戦者がいなくてもスコープ選択ドロップダウンが出ている" do
    visit_app(room_code: :my_room, fixed_user_name: "alice", fixed_order_names: "alice", autoexec: "message_modal_handle")
    assert_selector(".MessageSendModal .message_scope_dropdown")
  end

  it "Enterで送信できる" do
    visit_app(room_code: :my_room, fixed_user_name: "alice", autoexec: "message_modal_handle")
    within(".MessageSendModal") do
      find(:fillable_field).set(message1)
      find(:fillable_field).send_keys("\n")
    end
    assert_message_received_o(message1)
  end

  def assert_message_received_o(message)
    within(".MessageSendModal") do
      assert_selector(".message_body", text: message, exact_text: true)
    end
  end

  def assert_message_received_x(message)
    within(".MessageSendModal") do
      assert_no_selector(".message_body", text: message, exact_text: true)
    end
  end

  # 指定のスコープにしてからメッセージ送信
  def scoped_message_send(message_scope_key, message)
    within(".MessageSendModal") do
      find(".message_scope_dropdown").click          # スコープ選択ドロップダウンを開く
      find(".dropdown .#{message_scope_key}").click  # スコープ選択
      find(:fillable_field).set(message)             # メッセージ入力
      find(".send_handle").click                     # 送信
    end
  end
end
