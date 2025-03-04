import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class ShortcutInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      {
        _if: (c, e) => c.play_mode_p && e.key === "?",
        call: c => c.shortcut_modal_shortcut_handle(),
      },
      {
        _if: (c, e) => c.play_mode_p && c.keyboard_single_code_equal(e, "Enter"),
        call: c => c.chat_modal_shortcut_handle(),
      },
      {
        _if: (c, e) => c.play_mode_p && c.keyboard_single_key_equal(e, "i"),
        call: c => c.rsm_open_shortcut_handle(),
      },
      {
        _if: (c, e) => c.play_mode_p && c.keyboard_single_key_equal(e, "o"),
        call: c => c.os_modal_shortcut_handle(),
      },
      {
        _if: (c, e) => c.play_mode_p && c.keyboard_single_key_equal(e, "c"),
        call: c => c.cc_modal_shortcut_handle(),
      },
      {
        _if: (c, e) => c.play_mode_p && c.keyboard_single_key_equal(e, "m"),
        call: c => c.think_mark_toggle_button_click_handle(),
      },
      {
        _if: (c, e) => c.play_mode_p && c.keyboard_single_key_equal(e, "z"),
        call: c => c.honpu_return_click_handle(),
      },
      {
        _if: (c, e) => c.play_mode_p && e.code === "KeyE" && c.keyboard_shift_p(e),
        call: c => c.edit_mode_handle(),
      },
      {
        _if: (c, e) => c.edit_mode_p && e.code === "KeyE" && c.keyboard_shift_p(e),
        call: c => c.play_mode_handle(),
      },
      {
        _if: (c, e) => c.play_mode_p && e.code === "KeyC" && c.keyboard_shift_p(e),
        call: c => c.kifu_copy_handle("kif_utf8"),
      },
      {
        _if: (c, e) => c.play_mode_p && e.code === "KeyV" && c.keyboard_shift_p(e),
        call: c => c.yomikomi_from_clipboard(),
      },
      {
        _if: (c, e) => c.play_mode_p && c.keyboard_single_key_equal(e, ","),
        call: c => c.general_setting_modal_shortcut_handle(),
      },
    ]
  }
}
