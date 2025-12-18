module SbSupportMethods
  def chat_modal_open(&block)
    find(".chat_modal_open_handle").click
    if block_given?
      yield
      chat_modal_close
    end
  end

  def chat_modal_close
    find(".ChatModal .close_handle").click
  end

  # message を送信する
  def chat_message_send(message)
    within(".ChatModal") do
      find(:fillable_field).set(message)          # メッセージ入力
      find(:button, :class => "send_handle").click # 送信
    end
  end

  # 開いて送信して閉じる
  def chat_message_send2(message)
    chat_modal_open
    chat_message_send(message)
    chat_modal_close
  end

  # 最後に送信した人の名前
  def assert_message_latest_from(name, options = {})
    assert_selector(".ChatModal .SbAvatarLine:last-of-type .name_block", { text: name, exact_text: true }.merge(options))
  end

  # 最後に送信した人の名前
  def assert_no_message_latest_from(name, options = {})
    assert_no_selector(".ChatModal .SbAvatarLine:last-of-type .name_block", { text: name, exact_text: true }.merge(options))
  end

  # 何かの message を受信した
  def assert_message_body(options = {})
    assert_selector(".ChatModal .message_body", options)
  end

  # message を受信した
  def assert_message_received_o(message, options = {})
    assert_selector(".ChatModal .message_body", options)
    assert_selector(".ChatModal .message_body", { text: message, exact_text: true }.merge(options))
  end

  # message を受信していない
  def assert_message_received_x(message)
    assert_no_selector(".ChatModal .message_body", text: message, exact_text: true)
  end

  # 指定のスコープに変更する
  def message_scope_key_set(message_scope_key)
    find(".ChatModal .message_scope_dropdown").click          # スコープ選択ドロップダウンを開く
    find(".ChatModal .dropdown .#{message_scope_key}").click  # スコープ選択
    assert_message_scope_key(message_scope_key)    # 指定のスコープになっている
  end

  # 指定のスコープにしてからメッセージ送信
  def scoped_message_send(message_scope_key, message)
    message_scope_key_set(message_scope_key)
    chat_message_send(message)
  end

  # 下スクロールさせて上に行く(過去を見る)
  def chat_scroll_to_top
    Capybara.execute_script(%(document.querySelector(".SbMessageBox").scrollTop = 0))
  end

  # 読み込みが終わるまで待つ。これがないと assert_mh_page_index_in_modal が不安定になる
  def chat_scroll_read_wait
    sleep 1.0
  end

  # 下スクロールさせて上に行く
  def chat_scroll_to_top_with_wait
    chat_scroll_to_top
  end

  # 上スクロールさせて下に行く(最新を見る)
  def chat_scroll_to_bottom
    Capybara.execute_script(%(document.querySelector(".SbMessageBox").scrollTop = document.querySelector(".SbMessageBox").scrollHeight))
  end

  # どこまでスクロールしているかを返す
  # これ絵文字(img)をSbAvatarLineの中で表示しなければ (scrollTop + clientHeight) == scrollHeight になるのだが、
  # 絵文字(img)があると、それが影響して 1px ずれたりする
  # したがって比率で調べる
  def chat_scroll_ratio
    scrollTop = Capybara.execute_script(%(return document.querySelector(".SbMessageBox").scrollTop))
    clientHeight = Capybara.execute_script(%(return document.querySelector(".SbMessageBox").clientHeight))
    scrollHeight = Capybara.execute_script(%(return document.querySelector(".SbMessageBox").scrollHeight))
    (scrollTop + clientHeight).fdiv(scrollHeight)
  end

  # 発言を count 件用意する
  def chat_message_setup(count)
    eval_code %(ShareBoard::Room.fetch(:test_room).setup_for_test(count: #{count}, force: true))
  end

  # 発言読み込み数
  def assert_ml_count_in_modal(count, **options)
    assert_selector(".ChatModal .ml_count", text: count.to_s, exact_text: true, **options)
  end

  # API実行回数
  def assert_mh_page_index_in_modal(index, **options)
    # options = { wait: 2.0 }.merge(options)
    chat_scroll_read_wait
    assert_selector(".ChatModal .mh_page_index", text: index.to_s, exact_text: true, **options)
  end

  # 指定のスコープになっている
  def assert_message_scope_key(message_scope_key)
    assert_selector(".ChatModal .send_handle.#{message_scope_key}")
  end
end
