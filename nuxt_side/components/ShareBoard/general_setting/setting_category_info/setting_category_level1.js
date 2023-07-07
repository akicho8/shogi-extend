import { SettingCategoryBase } from "./setting_category_base.js"

export class SettingCategoryLevel1 extends SettingCategoryBase {
  static get define() {
    return [
      { key: "byoyomi_mode_key",     },
      { key: "yomiage_mode_key",     },
      { key: "next_turn_call_key",   },
      { key: "send_trigger_key",     },
    ]
  }
}
