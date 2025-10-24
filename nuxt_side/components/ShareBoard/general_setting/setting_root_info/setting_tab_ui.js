import { SettingTabBase } from "./setting_tab_base.js"

export class SettingTabUi extends SettingTabBase {
  static get define() {
    return [
      { key: "lift_cancel_action", show: true, },
      { key: "send_trigger_key",   show: true, },
    ]
  }
}
