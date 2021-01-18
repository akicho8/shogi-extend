module Wbook
  Config = {
    :revision                        => 25,
    :wbook_display_p                  => true,

    # -------------------------------------------------------------------------------- 共通
    :rating_display_p                => true, # 内部レーティングを表示する？
    :action_cable_debug              => true, # ActionCable関連デバッグモード
    :user_name_required              => true, # 「名無し」であれば名前を入力してもらう
    :emotion_editable_p              => true, # エモーション編集機能有効化
    :o_ucount_notify_func_p          => true, # 何問解いたか通知

    # -------------------------------------------------------------------------------- マッチング
    :matching_gap_base               => 7,  # ○**カウンター
    :matching_pow_base               => 50, # gap < 2**(○+カウンター) ならマッチングする
    :matching_interval_second        => 3,  # カウンターをインクリメントする間隔(秒)
    :matching_forgo_second           => 10, # ○秒たったらマッチングを諦める(nullなら無限)

    # -------------------------------------------------------------------------------- バトル中の設定
    # 共通
    :leader_index                    => 1,        # シングルトンとハイブリッドルールのときの memberships のインデックス○をリーダーにする。:0 =>左側 1:右側
    :self_is_left_side_p             => false,    # 自分を左に表示
    :ox_status_line_take_n           => 8,        # 上の○×行は最新何個表示する？
    :deden_delay                     => 0.8,      # 「デデン」の待ち

    # シングルトンモード
    :otetuki_release_p               => false, # おてつき解除可能か？
    :turn_limit_lazy_count           => 4,     # 3手詰なら○手足した手数まで操作できる
    :singleton_giveup_effective_seconds           => 1,     # 「あきらめる」がでるまでの秒数(シングルトン)

    # マラソンモード
    :marathon_giveup_effective_seconds            => 1,     # 「あきらめる」がでるまでの秒数(マラソン)

    # -------------------------------------------------------------------------------- バトル部屋チャット
    :room_messages_display_p         => true,  # 部屋でのチャット表示
    :room_messages_window_height     => 10,    # 部屋での表示行数
    :question_messages_window_height => 5,     # 問題での表示行数(未使用)
    :room_message_drop_lines         => 20,    # 部屋での表示行数(データ)

    # -------------------------------------------------------------------------------- プロフィール編集画面
    :profile_save_and_return         => true, # プロフィール編集画面で「保存」と同時に戻るか？

    # -------------------------------------------------------------------------------- フッター
    :footer_hidden_function          => false, # スクロールで隠すか？

    # -------------------------------------------------------------------------------- 問題作成フォーム
    :hint_enable                     => false, # ヒントカラムを有効にする？
    :save_and_back_to_index          => true,  # 「保存」したら一覧に戻る？
    :difficulty_level_max            => 5,     # ★の最大数
    :time_limit_sec_enable           => false, # 時間制限のカラムを有効にする？
    :difficulty_level_enable         => false, # 難易度カラムを表示する？
    :turm_max_limit                  => 3,     # 手数制限

    # -------------------------------------------------------------------------------- API
    :api_questions_fetch_per         => 5,  # 問題一覧での1ページあたりの表示件数
    :api_lobby_message_max           => 100, # ロビーのメッセージ表示件数
    :api_history_fetch_max           => 50, # 履歴表示件数
    :api_clip_fetch_max              => 50, # 保存表示件数
  }

  if Rails.env.staging? || Rails.env.production?
    Config.update({
        :room_messages_display_p         => false,    # 部屋でのチャット表示
        :matching_pow_base               => 6,        # gap < 2**(○+カウンター) ならマッチングする
        :matching_interval_second        => 4,        # カウンターをインクリメントする間隔(秒)
        :room_messages_window_height     => 5,        # 部屋での表示行数
        :matching_forgo_second           => 60*5,     # ○秒たったらマッチングを諦める(nullなら無限)
        :action_cable_debug              => false,    # ActionCable関連デバッグモード
        :api_questions_fetch_per         => 50,       # 問題一覧での1ページあたりの表示件数
        :self_is_left_side_p             => true,     # 自分を左に表示
        :turm_max_limit                  => 13,       # 手数制限
        :singleton_giveup_effective_seconds           => 3,        # 「あきらめる」がでるまでの秒数(シングルトン)
        :marathon_giveup_effective_seconds            => 15,       # 「あきらめる」がでるまでの秒数(マラソン)
        :sp_theme                        => "real",   # 将棋盤のタイプ
        :emotion_editable_p              => false,    # エモーション編集機能有効化
        :o_ucount_notify_func_p          => false,    # 何問解いたか通知
      })
  end
end
