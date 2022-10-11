export const AppConfig = {
  ALIVE_NOTIFY_INTERVAL: 30,   // N秒ごとに存在を通知する
  ALIVE_SEC: 30 + 5,           // N秒未満なら活発とみなす
  KILL_SEC: 30 + 30,           // 通知がN秒前より古いユーザーは破棄

  WATCH_AND_URL_REPLACE: false, // URLを常時置換するか？

  TORYO_THEN_CURRENT_LOCATION_IS_LOSE: false, // 誰が投了したかに関係なく現在の色のチームが負け(二歩の場合手番が進むため支障あり)
}
