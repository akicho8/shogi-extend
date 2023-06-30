import { SettingCategoryBase } from "./setting_category_base.js"

export class SettingCategoryLevel3 extends SettingCategoryBase {
  static get define() {
    return [
      { key: "lift_cancel_action",   },
      { key: "ctrl_mode_key",        },
    ]
  }
}
