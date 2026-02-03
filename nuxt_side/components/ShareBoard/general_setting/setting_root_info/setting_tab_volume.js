import { SettingTabBase } from "./setting_tab_base.js"

export class SettingTabVolume extends SettingTabBase {
  static get define() {
    return [
      { key: "volume_common_user_scale",  show: true, }, // グローバルに反映する
      { key: "volume_talk_user_scale",    show: true, }, // グローバルに反映する
      { key: "volume_clock_user_scale",   show: true, }, // 共有将棋盤内だけで使う
      { key: "volume_piece_user_scale", show: true, }, // 共有将棋盤内だけで使う
    ]
  }
}
