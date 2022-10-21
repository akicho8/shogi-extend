module SharedMethods
  # message を送信する
  def chat_message_send(message)
    within(".MessageSendModal") do
      find(:fillable_field).set(message)          # メッセージ入力
      find(:button, :class => "send_handle").click # 送信
    end
  end

  # message を受信した
  def assert_message_received_o(message, options = {})
    within(".MessageSendModal") do
      assert_selector(".message_body", {text: message, exact_text: true}.merge(options))
    end
  end

  # message を受信していない
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
