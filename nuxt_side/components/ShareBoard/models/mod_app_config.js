// システムテスト時の初期値
// ../../../../spec/system/share_board/shared_methods/setup.rb

export const AppConfig = {
  ALIVE_NOTIFY_INTERVAL: 30,                  // N秒ごとに存在を通知する
  ALIVE_SEC: 30 + 5,                          // N秒未満なら活発とみなす
  KILL_SEC: 30 + 30,                          // 通知がN秒前より古いユーザーは破棄

  WATCH_AND_URL_REPLACE: false,               // URLを常時置換するか？

  TORYO_THEN_CURRENT_LOCATION_IS_LOSE: false, // 誰が投了したかに関係なく現在の色のチームが負け(二歩の場合手番が進むため支障あり)
  TALK_MAKEMASHITA_MESSAGE: false,                 // 「負けました」と発言する？
  ENDING_MODAL_USE: false,                    // 最後のモーダルを表示する？

  CHAT_BLANK_MESSAGE_POST_THEN_CLOSE: true,   // チャットを空送信で閉じるか？

  NAVBAR_COLOR_CHANGE: false,                 // 残り時間によってバーの色を変更するか？

  ai_active: true,                         // ChatGPT を有効にするか？

  STORAGE_KEY_SUFFIX_NEW: "/V1",              // localStorage のキーの新しいサフィックス 例: "/V1"
  STORAGE_KEY_SUFFIX_OLD: "",                 // localStorage のキーの古いサフィックス 例: "/V1"

  CLOCK_START_CONFIRM: false,                 // 途中の局面から対局開始した際に確認するか？

  foul_mode_ui_show: true,                    // 反則なしにできるようにする

  think_mark_invite_watcher_count_skip: true, // 対局開始時には観戦者の数とかに関係なく思考印への導線ダイアログを表示する

  avatar: {
    profile_image_first_use: true,            // プロフィール画像を優先的に使うか？
    pepper_date_format: "YYYY-MM-DD",         // アバターが変化するタイミング。毎日なら"YYYY-MM-DD"。固定でいいなら "-"。空にすると秒単位の時間になるので注意
    avatar_history_take: 10,                  // アバターを履歴に残す件数
  },

  //// ---------------------------------------- 動作に関係ない見た目の制御

  // ☗☖をアバターに置き換えた場合には駒台の上のプレイヤー名の前に☗☖入れるか？
  player_name_prefix_pentagon_feature: false,

  // 反則ブロック
  illegal_takeback: {
    lifted_piece_cancel: false, // 反則ブロック時に持った駒を離すか？
    // anyone_block_can_p: true,   // 誰でも「なかったことにする」ことができるか？
  },
}

if (process.env.NODE_ENV === "development") {
  // AppConfig.player_name_prefix_pentagon_feature = false
  // AppConfig.NAVBAR_COLOR_CHANGE          = true
}
