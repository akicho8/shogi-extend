module Xclock
  Config = {
    :revision                        => 23,
    :xclock_display_p                  => true,
    :promotion_for_training          => false,

    # -------------------------------------------------------------------------------- 共通
    :lobby_clock_restrict_p          => false, # ルールの開催期間制限
    :lobby_clock_restrict_ranges     => [{:beg => "15:14:00", :end => "15:14:05" }, {:beg => "23:00", :end => "23:55" }],
    :rating_display_p                => true, # 内部レーティングを表示する？
    :action_cable_debug              => true, # ActionCable関連デバッグモード
    :user_name_required              => true, # 「名無し」であれば名前を入力してもらう
    :emotion_editable_p              => true, # エモーション編集機能有効化
    :o_ucount_notify_func_p         => true, # 何問解いたか通知

    # -------------------------------------------------------------------------------- マッチング
    :matching_gap_base               => 7,  # ○**カウンター
    :matching_pow_base               => 50, # gap < 2**(○+カウンター) ならマッチングする
    :matching_interval_second        => 3,  # カウンターをインクリメントする間隔(秒)
    :matching_forgo_second           => 10, # ○秒たったらマッチングを諦める(nullなら無限)
    :matching_cancel_possible_second => 2,  # ○秒たったらマッチングを諦めることができる(nullなら諦めることができない)

    # -------------------------------------------------------------------------------- バトル中の設定
    # 共通
    :leader_index                    => 1,        # シングルトンとハイブリッドルールのときの memberships のインデックス○をリーダーにする。:0 =>左側 1:右側
    :self_is_left_side_p             => false,    # 自分を左に表示
    :ox_status_line_take_n           => 8,        # 上の○×行は最新何個表示する？
    :readygo_delay                   => 2.2,      # 「対戦開始！」の待ち
    :deden_delay                     => 0.8,      # 「デデン」の待ち
    :sp_theme                        => "real",   # 将棋盤のタイプ
    :sp_size                         => "large",  # 将棋盤の大きさ

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
    :api_lobby_message_max           => 50, # ロビーのメッセージ表示件数
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
        :matching_cancel_possible_second => 30,       # ○秒たったらマッチングを諦めることができる
        :action_cable_debug              => false,    # ActionCable関連デバッグモード
        :api_questions_fetch_per         => 50,       # 問題一覧での1ページあたりの表示件数
        :self_is_left_side_p             => true,     # 自分を左に表示
        :turm_max_limit                  => 13,       # 手数制限
        :singleton_giveup_effective_seconds           => 3,        # 「あきらめる」がでるまでの秒数(シングルトン)
        :marathon_giveup_effective_seconds            => 15,       # 「あきらめる」がでるまでの秒数(マラソン)
        :sp_theme                        => "real",   # 将棋盤のタイプ
        :emotion_editable_p              => false,    # エモーション編集機能有効化
        :o_ucount_notify_func_p         => false,    # 何問解いたか通知
        :lobby_clock_restrict_p          => false,    # ルールの開催期間制限
        :lobby_clock_restrict_ranges              => [
          # { :beg => "12:45", :end => "13:00" },
          { :beg => "23:00", :end => "23:15" },
        ],
      })
  end

  if Rails.env.staging?
    Config.update({
        :lobby_clock_restrict_ranges              => [
          # { :beg => "12:45", :end => "13:00" },
          { :beg => "21:00", :end => "21:09" },
          { :beg => "21:10", :end => "21:19" },
          { :beg => "21:20", :end => "21:29" },
          { :beg => "21:30", :end => "21:39" },
          { :beg => "21:40", :end => "21:49" },
          { :beg => "21:50", :end => "21:59" },
          { :beg => "22:00", :end => "22:09" },
          { :beg => "22:10", :end => "22:19" },
          { :beg => "22:20", :end => "22:29" },
          { :beg => "22:30", :end => "22:39" },
          { :beg => "22:40", :end => "22:49" },
          { :beg => "22:50", :end => "22:59" },
          { :beg => "23:00", :end => "23:15" },
        ],
      })
  end
end
