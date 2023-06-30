import { SettingCategoryBase } from "./setting_category_base.js"

export class SettingCategoryLevel2 extends SettingCategoryBase {
  static get define() {
    return [
      { key: "talk_volume",  column_class: "is-12-tablet", }, // グローバルに反映する
      { key: "clock_volume", column_class: "is-12-tablet", }, // 共有将棋盤内だけで使う
    ]
  }
}
