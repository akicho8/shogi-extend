import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class ShortcutInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      {
        _if: (c, e) => c.keyboard_single_key_equal(e, "c"),
        call: (c, e) => c.kifu_copy_first(e, {format: "kif"}),
      }, {
        _if: (c, e) => c.keyboard_single_key_equal(e, "s"),
        call: (c, e) => c.kifu_save_shortcut_handle(e),
      }, {
        _if: (c, e) => c.keyboard_single_key_equal(e, "x"),
        call: (c, e) => c.kifu_copy_first(e, {format: "ki2"}),
      }, {
        _if: (c, e) => c.keyboard_single_key_equal(e, "n"),
        call: (c, e) => c.page_forward(1),
      }, {
        _if: (c, e) => c.keyboard_single_key_equal(e, "p"),
        call: (c, e) => c.page_forward(-1),
      }, {
        _if: (c, e) => c.keyboard_single_key_equal(e, "o"),
        call: (c, e) => c.show_url_all_open_handle(),
      }, {
        _if: (c, e) => c.keyboard_single_key_equal(e, "/"),
        call: (c, e) => c.search_input_focus(),
      }, {
        _if: (c, e) => e.key === "1",
        call: (c, e) => c.layout_key_set("is_layout_table", e),
      }, {
        _if: (c, e) => e.key === "2",
        call: (c, e) => c.scene_key_set("critical_turn", e),
      }, {
        _if: (c, e) => e.key === "3",
        call: (c, e) => c.scene_key_set("outbreak_turn", e),
      }, {
        _if: (c, e) => e.key === "4",
        call: (c, e) => c.scene_key_set("turn_max", e),
      }, {
        _if: (c, e) => c.keyboard_single_key_equal(e, "i"),
        call: (c, e) => c.goto_player_info(e),
      }, {
        _if: (c, e) => c.keyboard_single_key_equal(e, "f"),
        call: (c, e) => c.goto_custom_search(e),
      }, {
        _if: (c, e) => e.key === "?",
        call: (c, e) => c.shortcut_modal_toggle_handle(),
      },

      // {
      //   _if: (c, e) => c.keyboard_single_code_equal(e, "Enter"),
      //   call: (c, e) => c.chat_modal_shortcut_handle(),
      // },
      // {
      //   _if: (c, e) => c.keyboard_single_key_equal(e, "i"),
      //   call: (c, e) => c.gate_modal_open_handle(),
      // },
      // {
      //   _if: (c, e) => c.keyboard_single_key_equal(e, "o"),
      //   call: (c, e) => c.os_modal_open_handle(),
      // },
      // {
      //   _if: (c, e) => c.keyboard_single_key_equal(e, "c"),
      //   call: (c, e) => c.cc_modal_open_handle(),
      // },
      // {
      //   _if: (c, e) => e.code === "KeyC" && c.keyboard_shift_p(e),
      //   call: (c, e) => c.kifu_copy_handle("kif_utf8"),
      // },
      // {
      //   _if: (c, e) => e.code === "KeyV" && c.keyboard_shift_p(e),
      //   call: (c, e) => c.kifu_read_from_clipboard(),
      // },
      // {
      //   _if: (c, e) => c.keyboard_single_key_equal(e, ","),
      //   call: (c, e) => c.general_setting_modal_shortcut_handle(),
      // },
    ]
  }
}
