import { SettingTabBase } from "./setting_tab_base.js"

export class SettingTabVolume extends SettingTabBase {
  static get define() {
    return [
      { key: "common_volume_scale",  column_class: "is-12-tablet", }, // グローバルに反映する
      { key: "talk_volume_scale",    column_class: "is-12-tablet", }, // グローバルに反映する
      { key: "clock_volume_scale",   column_class: "is-12-tablet", }, // 共有将棋盤内だけで使う
      { key: "komaoto_volume_scale", column_class: "is-12-tablet", }, // 共有将棋盤内だけで使う
    ]
  }
}
