import { SettingTabBase } from "./setting_tab_base.js"

export class SettingTabUi extends SettingTabBase {
  static get define() {
    return [
      { key: "chat_content_scale_key", show: true,  resetable: true, component_name: "SettingInput", },
      { key: "lift_cancel_action",     show: true,  resetable: true, component_name: "SettingInput", },
      { key: "send_trigger_key",       show: false, resetable: true, component_name: "SettingInput", },
    ]
  }
}
