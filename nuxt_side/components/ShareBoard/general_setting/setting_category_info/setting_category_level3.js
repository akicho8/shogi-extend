import { SettingCategoryBase } from "./setting_category_base.js"

export class SettingCategoryLevel3 extends SettingCategoryBase {
  static get define() {
    return [
      { key: "ctrl_mode_key",        },
      { key: "illegal_behavior_key", },
    ]
  }
}
