import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import { SettingCategoryLevel1 } from "./setting_category_info/setting_category_level1.js"
import { SettingCategoryLevel2 } from "./setting_category_info/setting_category_level2.js"
import { SettingCategoryLevel3 } from "./setting_category_info/setting_category_level3.js"
import { SettingCategoryLevel4 } from "./setting_category_info/setting_category_level4.js"

export class SettingCategoryInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "setting_category2", name: "音量",       list: SettingCategoryLevel2, },
      { key: "setting_category1", name: "実況者向け", list: SettingCategoryLevel1, },
      { key: "setting_category3", name: "その他",     list: SettingCategoryLevel3, },
      { key: "setting_category4", name: "危険",       list: SettingCategoryLevel4, },
    ]
  }
}
