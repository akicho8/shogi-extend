import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class ShortcutInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      {
        _if: (c, e) => e.key === "?",
        call: c => c.shortcut_modal_shortcut_handle(),
      },
      {
        _if: (c, e) => c.keyboard_single_code_equal(e, "Space"),
        call: c => c.chat_modal_shortcut_handle(),
      },
      {
        _if: (c, e) => c.keyboard_single_key_equal(e, "i"),
        call: c => c.room_setup_modal_toggle_handle(),
      },
      {
        _if: (c, e) => c.keyboard_single_key_equal(e, "o"),
        call: c => c.os_modal_shortcut_handle(),
      },
      {
        _if: (c, e) => c.keyboard_single_key_equal(e, "t"),
        call: c => c.cc_modal_shortcut_handle(),
      },
      {
        _if: (c, e) => e.code === "KeyC" && c.keyboard_shift_p(e),
        call: c => c.kifu_copy_handle("kif_utf8"),
      },
      {
        _if: (c, e) => e.code === "KeyV" && c.keyboard_shift_p(e),
        call: c => c.yomikomi_from_clipboard(),
      },
      {
        _if: (c, e) => c.keyboard_single_key_equal(e, ","),
        call: c => c.general_setting_modal_shortcut_handle(),
      },
    ]
  }
}
