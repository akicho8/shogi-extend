import { SettingTabBase } from "./setting_tab_base.js"

export class SettingTabStreamer extends SettingTabBase {
  static get define() {
    return [
      { key: "next_turn_call_key",     show: true, resetable: true, component_name: "SettingInput", },
      { key: "chat_talk_behavior_key", show: true, resetable: true, component_name: "SettingInput", },
      { key: "byoyomi_mode_key",       show: true, resetable: true, component_name: "SettingInput", },
      { key: "vibration_mode_key",     show: true, resetable: true, component_name: "SettingInput", },
    ]
  }
}
