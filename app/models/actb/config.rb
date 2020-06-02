module Actb
  Config = {
    # マッチング
    math_pow_ruijou_base: 50,    # gap < 2**(○+カウンター) ならマッチングする
    matching_interval_second: 3, # カウンターをインクリメントする間隔(秒)

    best_questions_limit: 10, # 問題数

    # マラソンモード
    progress_list_take_display_count: 8, # ○×は最新何個表示する？

    # シングルトンモード
    ikkai_misuttara_mou_osenai: true, # 誤答すると相手が誤答するまで解答ボタンを押せない？
    q2_time_limit_sec: 300,           # 1手は○秒以内に操作しないとタイムアウトになる
    b_score_max_for_win: 5,           # スコア5に足っしたら勝ち
    asobi_count: 4,                   # 3手詰なら○手足した手数まで操作できる

    # 各タイミング
    readygo_wait_delay: 2.2,
    deden_mode_delay: 0.8,

    # チャット
    room_messages_display_lines: 20,
    question_messages_display_lines: 5,

    # UI
    save_and_return: true, # プロフィール編集画面で「保存」と同時に戻るか？
  }
end
