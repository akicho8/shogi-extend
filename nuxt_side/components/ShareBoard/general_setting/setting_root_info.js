import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

import { SettingTabStreamer } from "./setting_root_info/setting_tab_streamer.js"
import { SettingTabVolume   } from "./setting_root_info/setting_tab_volume.js"
import { SettingTabOther    } from "./setting_root_info/setting_tab_other.js"
import { SettingTabDanger   } from "./setting_root_info/setting_tab_danger.js"
import { SettingTabUi       } from "./setting_root_info/setting_tab_ui.js"

export class SettingRootInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "setting_tab_streamer", name: "音響忌避者向け", tab_model: SettingTabStreamer, show: true,  },
      { key: "setting_tab_ui",       name: "UI",         tab_model: SettingTabUi,       show: true,  },
      { key: "setting_tab_volume",   name: "音量",       tab_model: SettingTabVolume,   show: true,  },
      { key: "setting_tab_other",    name: "その他",     tab_model: SettingTabOther,    show: true,  },
      // 非表示は一番最後にすること
      // なぜならタブインデックスがずれて異なる name をしゃべってしまう
      { key: "setting_tab_danger",   name: "危険",       tab_model: SettingTabDanger,   show: false, },
    ]
  }

  showable_p(context) {
    return context.debug_mode_p || this.show
  }
}
