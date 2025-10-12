require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  let(:message1) { SecureRandom.hex }
  let(:message2) { SecureRandom.hex }

  it "メッセージが自分と相手に届く" do
    window_a do
      room_setup_by_user(:alice) # aliceが部屋を作る
    end
    window_b do
      room_setup_by_user(:bob) # bobも同じ入退室
    end
    window_a do
      find(".chat_modal_open_handle").click            # 開く
      chat_message_send(message1)
      assert_message_body(wait: 3)
      assert_message_received_o(message1, wait: 3)
    end
    window_b do
      find(".chat_modal_open_handle").click # 開く
      assert_message_received_o(message1) # bob にも届いた
    end
  end

  def case1(user_name)
    visit_room(user_name: user_name, fixed_order: :alice)
    chat_modal_open
  end

  it "観戦者宛送信" do
    window_a { case1(:alice) }
    window_b { case1(:bob) }
    window_c { case1(:carol) }

    window_b { scoped_message_send(:ms_private, message1) } # 観戦者の bob が観戦者送信した
    window_b { assert_message_received_o(message1)        } # 自分には (観戦者かに関係なく本人だから) 届いている
    window_a { assert_message_received_x(message1)        } # alice には対局者なので届いていない
    window_c { assert_message_received_o(message1)        } # carol には観戦者なので届いている

    window_a { scoped_message_send(:ms_private, message2) } # 対局者の alice が送信した
    window_a { assert_message_received_o(message2)        } # 自分には (観戦者かに関係なく本人だから) 届いている
    window_b { assert_message_received_o(message2)        } # bob   には観戦者なので届いている
    window_c { assert_message_received_o(message2)        } # carol には観戦者なので届いている

    window_b do
      chat_modal_close
      order_set_off             # 順番設定を解除する
    end

    # bobが順番設定を解除したことで
    window_a do
      assert_message_received_o(message1)                      # bob の送信を alice は見えるようになった
      assert_no_selector(".ChatModal .message_scope_dropdown") # 順番設定を解除したためスコープ選択は表示されていない
    end
  end

  it "順番設定していたら観戦者がいなくてもスコープ選択ドロップダウンが出ている" do
    visit_room(user_name: :alice, fixed_order: :alice)
    chat_modal_open
    assert_selector(".ChatModal .message_scope_dropdown")
  end

  it "Enterで送信できる" do
    visit_room(user_name: :alice)
    chat_modal_open
    within(".ChatModal") do
      find(:fillable_field).set(message1)
      find(:fillable_field).send_keys("\n")
    end
    assert_message_received_o(message1)
  end
end
