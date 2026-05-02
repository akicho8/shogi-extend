import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import { GX } from "@/components/models/gx.js"
import { ShortcutInfo } from "./shortcut_info.js"

export class ShortcutCategoryInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "基本",   if_debug: false, },
      { key: "対局",   if_debug: false, },
      { key: "思考印", if_debug: false, },
      { key: "その他", if_debug: false, },
    ]
  }

  get shortcut_infos() {
    return ShortcutInfo.values.filter(e => e.category_key === this.key)
  }

  showable_p(context) {
    if (this.if_debug) {
      return context.debug_mode_p
    } else {
      return true
    }
  }
}
