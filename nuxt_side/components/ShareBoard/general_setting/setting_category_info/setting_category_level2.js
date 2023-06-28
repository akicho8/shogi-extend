import { SettingCategoryBase } from "./setting_category_base.js"

export class SettingCategoryLevel2 extends SettingCategoryBase {
  static get define() {
    return [
      { key: "foo1_volume", column_class: "is-12-tablet", },
    ]
  }
}
