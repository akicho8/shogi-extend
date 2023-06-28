import { SettingCategoryBase } from "./setting_category_base.js"

export class SettingCategoryLevel1 extends SettingCategoryBase {
  static get define() {
    return [
      { key: "yomiage_mode_key",   },
      { key: "lift_cancel_action", },
    ]
  }
}
