import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import { SettingCategoryLevel1 } from "./setting_category_info/setting_category_level1.js"
import { SettingCategoryLevel2 } from "./setting_category_info/setting_category_level2.js"
import { SettingCategoryLevel3 } from "./setting_category_info/setting_category_level3.js"
import { SettingCategoryLevel4 } from "./setting_category_info/setting_category_level4.js"
import { SettingCategoryLevel5 } from "./setting_category_info/setting_category_level5.js"

export class SettingCategoryInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "setting_category1", name: "実況配信者向け", items_model: SettingCategoryLevel1, show: true,  },
      { key: "setting_category5", name: "UI",             items_model: SettingCategoryLevel5, show: true,  },
      { key: "setting_category3", name: "その他",         items_model: SettingCategoryLevel3, show: true,  },
      { key: "setting_category2", name: "音量",           items_model: SettingCategoryLevel2, show: false, },
      { key: "setting_category4", name: "危険",           items_model: SettingCategoryLevel4, show: false, },
    ]
  }

  showable_p(context) {
    return context.debug_mode_p || this.show
  }
}
