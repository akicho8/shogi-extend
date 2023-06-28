import { SettingCategoryBase } from "./setting_category_base.js"

export class SettingCategoryLevel4 extends SettingCategoryBase {
  static get define() {
    return [
      { key: "quick_sync_key", },
      { key: "legal_key",      },
      { key: "debug_mode_key", },
    ]
  }
}
