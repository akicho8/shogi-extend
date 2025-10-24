import { SettingTabBase } from "./setting_tab_base.js"

export class SettingTabDanger extends SettingTabBase {
  static get define() {
    return [
      { key: "quick_sync_key", show: true, },
      { key: "legal_key",      show: true, },
      { key: "debug_mode_key", show: true, },
    ]
  }
}
