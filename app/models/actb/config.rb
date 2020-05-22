module Actb
  Config = {
    # マラソンモード
    progress_list_take_display_count: 8, # ○×は最新何個表示する？

    # シングルトンモード
    ikkai_misuttara_mou_osenai: true, # 誤答すると相手が誤答するまで解答ボタンを押せない？
    q2_time_limit_sec: 3,             # 1手は○秒以内に操作しないとタイムアウトになる
    nanmonkotaetara_kati: 5,          # ○問正解したら勝ち

    # 各タイミング
    readygo_wait_delay: 2.5,
    deden_mode_delay: 0.8,
    correct_mode_delay: 1,
    mistake_mode_delay: 1,

    room_messages_display_lines: 20,
  }
end
