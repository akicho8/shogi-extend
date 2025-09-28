import { SettingTabBase } from "./setting_tab_base.js"

export class SettingTabUi extends SettingTabBase {
  static get define() {
    return [
      { key: "lift_cancel_action", },
      { key: "send_trigger_key",   },
    ]
  }
}
