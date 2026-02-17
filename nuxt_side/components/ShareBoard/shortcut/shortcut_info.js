import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import { GX } from "@/components/models/gx.js"

export class ShortcutInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      {
        _if: (c, e) => c.play_mode_p && e.key === "?",
        call: c => c.shortcut_modal_toggle_handle(),
      },
      {
        _if: (c, e) => c.play_mode_p && c.KeyboardHelper.pure_code_p(e, "Enter"),
        call: c => c.chat_modal_shortcut_handle(),
      },
      {
        _if: (c, e) => c.play_mode_p && c.KeyboardHelper.pure_key_p(e, "/"),
        call: c => c.sidebar_toggle_handle(),
      },
      {
        _if: (c, e) => c.play_mode_p && c.KeyboardHelper.pure_key_p(e, "0"),
        call: c => c.turn_change_to_zero_modal_open_handle(),
      },
      {
        _if: (c, e) => c.play_mode_p && c.KeyboardHelper.pure_key_p(e, "i"),
        call: c => c.board_preset_modal_open_handle(),
      },
      {
        _if: (c, e) => c.play_mode_p && c.KeyboardHelper.pure_key_p(e, "1"),
        call: c => c.gate_modal_open_handle(),
      },
      {
        _if: (c, e) => c.play_mode_p && (c.KeyboardHelper.pure_key_p(e, "2") || c.KeyboardHelper.pure_key_p(e, "o")),
        call: c => c.order_modal_open_handle(),
      },
      {
        _if: (c, e) => c.play_mode_p && (c.KeyboardHelper.pure_key_p(e, "3") || c.KeyboardHelper.pure_key_p(e, "t")),
        call: c => c.cc_modal_open_handle(),
      },
      {
        _if: (c, e) => c.play_mode_p && c.KeyboardHelper.pure_key_p(e, "m"),
        call: c => c.think_mark_toggle_button_click_handle(),
      },
      {
        _if: (c, e) => c.play_mode_p && c.KeyboardHelper.pure_key_p(e, "z"),
        call: c => c.honpu_return_click_handle(),
      },
      {
        _if: (c, e) => c.play_mode_p && e.code === "KeyE" && c.KeyboardHelper.shift_p(e),
        call: c => c.edit_mode_set_handle(),
      },
      {
        _if: (c, e) => c.edit_mode_p && e.code === "KeyE" && c.KeyboardHelper.shift_p(e),
        call: c => c.play_mode_set_handle(),
      },
      {
        _if: (c, e) => c.play_mode_p && e.key === "!",
        call: c => c.honpu_main_setup(),
      },
      {
        _if: (c, e) => c.play_mode_p && c.KeyboardHelper.pure_key_p(e, "c"),
        call: c => c.kifu_copy_handle("kif_utf8"),
      },
      {
        _if: (c, e) => c.play_mode_p && c.KeyboardHelper.pure_key_p(e, "s"),
        call: c => c.current_short_url_copy_handle(),
      },
      {
        _if: (c, e) => c.play_mode_p && c.KeyboardHelper.pure_key_p(e, "u"),
        call: c => c.current_url_copy_handle(),
      },
      {
        _if: (c, e) => c.play_mode_p && c.KeyboardHelper.pure_key_p(e, "b"),
        call: c => c.kifu_copy_handle(c.FormatTypeInfo.fetch("bod")),
      },
      {
        _if: (c, e) => c.play_mode_p && c.KeyboardHelper.pure_key_p(e, "d"),
        call: c => c.kifu_download_handle(c.FormatTypeInfo.fetch("kif_utf8")),
      },
      {
        _if: (c, e) => c.play_mode_p && c.KeyboardHelper.pure_key_p(e, "p"),
        call: c => c.cc_play_pause_resume_shortcut_handle(),
      },
      {
        _if: (c, e) => c.play_mode_p && c.KeyboardHelper.pure_key_p(e, "a"),
        call: c => c.avatar_input_modal_open_handle(),
      },
      {
        _if: (c, e) => c.play_mode_p && e.code === "KeyV" && c.KeyboardHelper.shift_p(e),
        call: c => c.kifu_read_from_clipboard(),
      },
      {
        _if: (c, e) => c.play_mode_p && e.code === "KeyR" && c.KeyboardHelper.shift_p(e),
        call: c => c.kifu_read_modal_open_handle(),
      },
      {
        _if: (c, e) => c.play_mode_p && c.KeyboardHelper.pure_key_p(e, ","),
        call: c => c.general_setting_modal_shortcut_handle(),
      },
      {
        _if: (c, e) => c.debug_mode_p && e.code === "Backslash",
        call: c => c.tl_modal_open_handle(),
      },
    ]
  }
}
