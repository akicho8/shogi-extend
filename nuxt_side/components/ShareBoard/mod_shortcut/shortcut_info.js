import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import { GX } from "@/components/models/gx.js"

export class ShortcutInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "shortcut_modal_toggle_handle",          kb_key: "?",          if_mode: "play", if_debug: false, },
      { key: "turn_change_to_zero_modal_open_handle", kb_key: "0",          if_mode: "play", if_debug: false, },
      { key: "board_preset_modal_open_handle",        kb_key: "i",          if_mode: "play", if_debug: false, },
      { key: "gate_modal_open_handle",                kb_key: "1",          if_mode: "play", if_debug: false, },
      { key: "order_modal_open_handle",               kb_key: ["2", "o"],   if_mode: "play", if_debug: false, },
      { key: "cc_modal_open_handle",                  kb_key: ["3", "t"],   if_mode: "play", if_debug: false, },
      { key: "think_mark_toggle_shortcut_handle",     kb_key: "m",          if_mode: "play", if_debug: false, },
      { key: "honpu_modal_open_handle",               kb_key: "h",          if_mode: "play", if_debug: false, },
      { key: "honpu_direct_return_handle",            kb_key: "z",          if_mode: "play", if_debug: false, },
      { key: "edit_mode_set_handle",                  kb_key: "E",          if_mode: "play", if_debug: false, },
      { key: "play_mode_set_handle",                  kb_key: "E",          if_mode: "edit", if_debug: false, },
      { key: "honpu_master_setup_for_shortcut",       kb_key: "W",          if_mode: "play", if_debug: false, },
      { key: "kifu_copy_handle_kif_utf8",             kb_key: "c",          if_mode: "play", if_debug: false, },
      { key: "current_short_url_copy_handle",         kb_key: "s",          if_mode: "play", if_debug: false, },
      { key: "current_long_url_copy_handle",          kb_key: "u",          if_mode: "play", if_debug: false, },
      { key: "kifu_copy_handle_bod",                  kb_key: "b",          if_mode: "play", if_debug: false, },
      { key: "kifu_download_handle_kif_utf8",         kb_key: "d",          if_mode: "play", if_debug: false, },
      { key: "cc_play_pause_resume_shortcut_handle",  kb_key: "p",          if_mode: "play", if_debug: false, },
      { key: "battle_list_modal_open_handle",         kb_key: "l",          if_mode: "play", if_debug: false, },
      { key: "battle_ranking_modal_open_handle",      kb_key: "r",          if_mode: "play", if_debug: false, },
      { key: "avatar_input_modal_open_handle",        kb_key: "a",          if_mode: "play", if_debug: false, },
      { key: "appearance_modal_open_handle",          kb_key: "g",          if_mode: "play", if_debug: false, },
      { key: "kifu_load_from_clipboard",              kb_key: "V",          if_mode: "play", if_debug: false, },
      { key: "kifu_loader_modal_open_handle",         kb_key: "R",          if_mode: "play", if_debug: false, },
      { key: "general_setting_modal_shortcut_handle", kb_key: ",",          if_mode: "play", if_debug: false, },
      { key: "chat_modal_shortcut_handle",            kb_code: "Enter",     if_mode: "all",  if_debug: false, },
      { key: "tl_modal_open_handle",                  kb_code: "Backslash", if_mode: "play", if_debug: true,  },
      { key: "think_mark_reject_action",              kb_code: "Backspace", if_mode: "play", if_debug: false, },
      { key: "sidebar_toggle_handle",                 kb_code: "Space",     if_mode: "play", if_debug: false, },
    ]
  }
}
