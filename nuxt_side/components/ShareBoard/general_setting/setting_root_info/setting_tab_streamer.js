import { SettingTabBase } from "./setting_tab_base.js"

export class SettingTabStreamer extends SettingTabBase {
  static get define() {
    return [
      { key: "yomiage_mode_key",   },
      { key: "next_turn_call_key", },
    ]
  }
}
