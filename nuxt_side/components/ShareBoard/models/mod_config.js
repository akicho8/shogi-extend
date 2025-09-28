export const AppConfig = {
  ALIVE_NOTIFY_INTERVAL: 30,                  // N秒ごとに存在を通知する
  ALIVE_SEC: 30 + 5,                          // N秒未満なら活発とみなす
  KILL_SEC: 30 + 30,                          // 通知がN秒前より古いユーザーは破棄

  WATCH_AND_URL_REPLACE: false,               // URLを常時置換するか？

  TORYO_THEN_CURRENT_LOCATION_IS_LOSE: false, // 誰が投了したかに関係なく現在の色のチームが負け(二歩の場合手番が進むため支障あり)

  CHAT_BLANK_MESSAGE_POST_THEN_CLOSE: true,   // チャットを空送信で閉じるか？

  CLOCK_PRESET_USE: false,                    // 対局時計の初期設定リストを(CcRuleInfo)を表示するか？

  NAVBAR_COLOR_CHANGE: false,                 // 残り時間によってバーの色を変更するか？

  GPT_FUNCTION: true,                         // ChatGPT を有効にするか？

  STORAGE_KEY_SUFFIX: "",                     // localStorage のキーのサフィックス 例: "/V1"

  CLOCK_START_CONFIRM: true,                  // 途中の局面から対局開始した際に確認するか？
}

if (process.env.NODE_ENV === "development") {
  AppConfig.CLOCK_PRESET_USE             = true
  // AppConfig.NAVBAR_COLOR_CHANGE          = true
}
