import { SettingTabBase } from "./setting_tab_base.js"

export class SettingTabOther extends SettingTabBase {
  static get define() {
    return [
      { key: "ai_mode_key",        },
      { key: "byoyomi_mode_key",   },
      { key: "vibration_mode_key", },
    ]
  }
}
