import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class ShortcutInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { input_key:   "?",     call: c => c.shortcut_modal_shortcut_handle() },
      // { sinelg_code: "Space", call: c => c.shortcut_modal_shortcut_handle() },
    ]
  }
}
