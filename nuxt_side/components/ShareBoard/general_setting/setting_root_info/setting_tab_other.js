import { SettingTabBase } from "./setting_tab_base.js"

export class SettingTabOther extends SettingTabBase {
  static get define() {
    return [
      { key: "ai_mode_key",             show: true, },
      { key: "byoyomi_mode_key",        show: true, },
      { key: "vibration_mode_key",      show: true, },
      { key: "pentagon_appearance_key", show: true, },
    ]
  }
}
