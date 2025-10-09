import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import { Gs } from "@/components/models/gs.js"

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
        _if: (c, e) => c.play_mode_p && c.keyboard_single_key_equal(e, "/"),
        call: c => c.sidebar_toggle(),
      },
      {
        _if: (c, e) => c.play_mode_p && c.keyboard_single_key_equal(e, "0"),
        call: c => c.turn_change_to_zero_modal_open_handle(),
      },
      {
        _if: (c, e) => c.play_mode_p && c.keyboard_single_key_equal(e, "i"),
        call: c => c.preset_select_modal_open_handle(),
      },
      {
        _if: (c, e) => c.play_mode_p && c.keyboard_single_key_equal(e, "1"),
        call: c => c.gate_modal_open_handle(),
      },
      {
        _if: (c, e) => c.play_mode_p && (c.keyboard_single_key_equal(e, "2") || c.keyboard_single_key_equal(e, "o")),
        call: c => c.os_modal_open_handle(),
      },
      {
        _if: (c, e) => c.play_mode_p && (c.keyboard_single_key_equal(e, "3") || c.keyboard_single_key_equal(e, "t")),
        call: c => c.cc_modal_open_handle(),
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
        _if: (c, e) => c.play_mode_p && e.key === "!",
        call: c => c.honpu_main_setup(),
      },
      {
        _if: (c, e) => c.play_mode_p && c.keyboard_single_key_equal(e, "c"),
        call: c => c.kifu_copy_handle("kif_utf8"),
      },
      {
        _if: (c, e) => c.play_mode_p && c.keyboard_single_key_equal(e, "u"),
        call: c => c.current_short_url_copy_handle(),
      },
      {
        _if: (c, e) => c.play_mode_p && c.keyboard_single_key_equal(e, "l"),
        call: c => c.current_url_copy_handle(),
      },
      {
        _if: (c, e) => c.play_mode_p && c.keyboard_single_key_equal(e, "b"),
        call: c => c.kifu_copy_handle(c.FormatTypeInfo.fetch("bod")),
      },
      {
        _if: (c, e) => c.play_mode_p && c.keyboard_single_key_equal(e, "s"),
        call: c => c.kifu_download_handle(c.FormatTypeInfo.fetch("kif_utf8")),
      },
      {
        _if: (c, e) => c.play_mode_p && c.keyboard_single_key_equal(e, "p"),
        call: c => c.cc_play_pause_resume_shortcut_handle(),
      },
      {
        _if: (c, e) => c.play_mode_p && e.code === "KeyV" && c.keyboard_shift_p(e),
        call: c => c.yomikomi_from_clipboard(),
      },
      {
        _if: (c, e) => c.play_mode_p && e.code === "KeyR" && c.keyboard_shift_p(e),
        call: c => c.yomikomi_modal_open_handle(),
      },
      {
        _if: (c, e) => c.play_mode_p && c.keyboard_single_key_equal(e, ","),
        call: c => c.general_setting_modal_shortcut_handle(),
      },
      {
        _if: (c, e) => c.debug_mode_p && e.code === "Backslash",
        call: c => c.tl_modal_handle(),
      },
    ]
  }
}
