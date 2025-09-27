import { SettingCategoryBase } from "./setting_category_base.js"

export class SettingCategoryLevel5 extends SettingCategoryBase {
  static get define() {
    return [
      { key: "lift_cancel_action", },
      { key: "send_trigger_key",   },
    ]
  }
}
