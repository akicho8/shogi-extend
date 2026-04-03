import { SettingTabBase } from "./setting_tab_base.js"

export class SettingTabUi extends SettingTabBase {
  static get define() {
    return [
      { key: "think_mark_switch_visibility_key", show: true,  resetable: true, component_name: "SettingInput", },
      { key: "chat_content_scale_key",           show: true,  resetable: true, component_name: "SettingInput", },
      { key: "send_trigger_key",                 show: false, resetable: true, component_name: "SettingInput", },
      { key: "lift_cancel_action",               show: true,  resetable: true, component_name: "SettingInput", },
      { key: "pentagon_appearance_key",          show: true,  resetable: true, component_name: "SettingInput", },
      { key: "ai_mode_key",                      show: true,  resetable: true, component_name: "SettingInput", },
    ]
  }
}
