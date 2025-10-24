import { SettingTabBase } from "./setting_tab_base.js"

export class SettingTabVolume extends SettingTabBase {
  static get define() {
    return [
      { key: "common_volume_scale",  show: true, }, // グローバルに反映する
      { key: "talk_volume_scale",    show: true, }, // グローバルに反映する
      { key: "clock_volume_scale",   show: true, }, // 共有将棋盤内だけで使う
      { key: "komaoto_volume_scale", show: true, }, // 共有将棋盤内だけで使う
    ]
  }
}
