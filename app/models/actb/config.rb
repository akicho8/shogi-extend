module Actb
  Config = {
    :actb_display_p              => true,

    # -------------------------------------------------------------------------------- 共通
    :rating_display_p                => false, # 内部レーティングを表示する？
    :action_cable_debug              => true,  # ActionCable関連デバッグモード
    :user_name_required              => true,  # 「名無し」であれば名前を入力してもらう

    # -------------------------------------------------------------------------------- マッチング
    :matching_gap_base               => 7,   # ○**カウンター
    :matching_pow_base               => 50,  # gap < 2**(○+カウンター) ならマッチングする
    :matching_interval_second        => 3,   # カウンターをインクリメントする間隔(秒)
    :matching_forgo_second           => 10,  # ○秒たったらマッチングを諦める(nullなら無限)

    # -------------------------------------------------------------------------------- バトル中の設定
    # 共通
    :leader_index                    => 1,        # シングルトンとハイブリッドルールのときの memberships のインデックス○をリーダーにする。:0 =>左側 1:右側
    :self_is_left_side_p               => false,    # 自分を左に表示
    :best_questions_limit            => 30,       # 準備する問題数でこれが尽きたら引き分け
    :b_score_max_for_win             => 5,        # ○問正解先取で勝ち
    :ox_status_line_take_n           => 8,        # 上の○×行は最新何個表示する？
    :readygo_delay              => 2.2,      # 「対戦開始！」の待ち
    :deden_delay                => 0.8,      # 「デデン」の待ち
    :sp_theme                        => 'simple', # 将棋盤のタイプ

    # シングルトンモード
    :otetuki_release_p               => false, # おてつき解除可能か？
    :s_time_limit_sec                => 4,     # 1手は○秒以内に操作しないとタイムアウトになる
    :time_limit_sec                  => nil,   # 解く時間 nil 以外ならそれに設定(productionならnilにすること)
    :turn_limit_lazy_count           => 4,     # 3手詰なら○手足した手数まで操作できる

    # -------------------------------------------------------------------------------- チャット
    :lobby_messages_window_height    => 12,   # ロビーでの表示行数
    :room_messages_window_height     => 10,   # 部屋での表示行数
    :question_messages_window_height => 5,    # 問題での表示行数(未使用)

    :room_message_drop_lines         => 20,   # 部屋での表示行数(データ)
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

    # -------------------------------------------------------------------------------- API
    :api_questions_fetch_per         => 5,
    :api_lobby_message_max           => 50,
    :api_history_fetch_max           => 50,
    :api_clip_fetch_max              => 50,
  }

  if Rails.env.staging? || Rails.env.production?
    Config.update({
        # :actb_display_p               => false, # リンクを表示する？
        :matching_pow_base            => 6,     # gap < 2**(○+カウンター) ならマッチングする
        :matching_interval_second     => 4,     # カウンターをインクリメントする間隔(秒)
        :time_limit_sec               => nil,   # 解く時間 nil:問題に設定した時間 整数値:一律この値に設定
        :room_messages_window_height  => 5,     # 部屋での表示行数
        :matching_forgo_second        => 60*5,  # ○秒たったらマッチングを諦める(nullなら無限)
        :action_cable_debug           => false, # ActionCable関連デバッグモード
        :api_questions_fetch_per      => 50,
        :self_is_left_side_p            => true,  # 自分を左に表示
      })
  end
end
