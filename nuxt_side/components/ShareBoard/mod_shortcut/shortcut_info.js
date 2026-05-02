import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import { GX } from "@/components/models/gx.js"

export class ShortcutInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { category_key: "基本",   name: "棋譜の張り付け",          trigger_type: "key",  trigger_key: "V",         if_mode: "play", if_debug: false, method: "kifu_load_from_clipboard",              },
      { category_key: "基本",   name: "棋譜の読み込み",          trigger_type: "key",  trigger_key: "R",         if_mode: "play", if_debug: false, method: "kifu_loader_modal_open_handle",         },
      { category_key: "基本",   name: "棋譜コピー (KIF)",        trigger_type: "key",  trigger_key: "c",         if_mode: "play", if_debug: false, method: "kifu_copy_handle_kif_utf8",             },
      { category_key: "基本",   name: "局面コピー (BOD)",        trigger_type: "key",  trigger_key: "b",         if_mode: "play", if_debug: false, method: "kifu_copy_handle_bod",                  },
      { category_key: "基本",   name: "棋譜ダウンロード (KIF)",  trigger_type: "key",  trigger_key: "d",         if_mode: "play", if_debug: false, method: "kifu_download_handle_kif_utf8",         },
      { category_key: "基本",   name: "棋譜URLコピー",           trigger_type: "key",  trigger_key: "u",         if_mode: "play", if_debug: false, method: "current_long_url_copy_handle",          },
      { category_key: "基本",   name: "棋譜URLコピー (短縮)",    trigger_type: "key",  trigger_key: "s",         if_mode: "play", if_debug: false, method: "current_short_url_copy_handle",         },
      { category_key: "基本",   name: "局面編集 / 完了",         trigger_type: "key",  trigger_key: "E",         if_mode: null,   if_debug: false, method: "play_edit_mode_toggle_handle",          },
      { category_key: "基本",   name: "現局面を本譜とする",      trigger_type: "key",  trigger_key: "W",         if_mode: "play", if_debug: false, method: "honpu_master_setup_for_shortcut",       },
      { category_key: "基本",   name: "本譜を開く",              trigger_type: "key",  trigger_key: "h",         if_mode: "play", if_debug: false, method: "honpu_modal_toggle_handle",             },
      { category_key: "基本",   name: "本譜に戻る",              trigger_type: "key",  trigger_key: "z",         if_mode: "play", if_debug: false, method: "honpu_direct_return_handle",            },

      { category_key: "対局",   name: "入退室 / 閉じる",         trigger_type: "key",  trigger_key: "e",         if_mode: "play", if_debug: false, method: "gate_modal_toggle_handle",              },
      { category_key: "対局",   name: "対局設定 / 閉じる",       trigger_type: "key",  trigger_key: "o",         if_mode: "play", if_debug: false, method: "order_modal_toggle_handle",             },
      { category_key: "対局",   name: "時計 / 閉じる",           trigger_type: "key",  trigger_key: "t",         if_mode: "play", if_debug: false, method: "cc_modal_toggle_handle",                },
      { category_key: "対局",   name: "一時停止 / 再開",         trigger_type: "key",  trigger_key: "p",         if_mode: "play", if_debug: false, method: "cc_play_pause_resume_shortcut_handle",  },
      { category_key: "対局",   name: "チャット / 閉じる",       trigger_type: "code", trigger_key: "Enter",     if_mode: null,   if_debug: false, method: "chat_modal_shortcut_handle",            },
      { category_key: "対局",   name: "初期配置に戻す",          trigger_type: "key",  trigger_key: "0",         if_mode: "play", if_debug: false, method: "turn_change_to_zero_modal_open_handle", },
      { category_key: "対局",   name: "手合割",                  trigger_type: "key",  trigger_key: "=",         if_mode: "play", if_debug: false, method: "board_preset_modal_open_handle",        },
      { category_key: "対局",   name: "対局履歴 / 閉じる",       trigger_type: "key",  trigger_key: "l",         if_mode: "play", if_debug: false, method: "battle_list_modal_toggle_handle",       },
      { category_key: "対局",   name: "ランキング / 閉じる",     trigger_type: "key",  trigger_key: "r",         if_mode: "play", if_debug: false, method: "battle_ranking_modal_toggle_handle",    },

      { category_key: "思考印", name: "モードのトグル",          trigger_type: "key",  trigger_key: "m",         if_mode: "play", if_debug: false, method: "think_mark_toggle_shortcut_handle",     },
      { category_key: "思考印", name: "一括消去",                trigger_type: "code", trigger_key: "Backspace", if_mode: "play", if_debug: false, method: "think_mark_reject_action",              },

      { category_key: "その他", name: "サイドバー / 閉じる",     trigger_type: "code", trigger_key: "Space",     if_mode: "play", if_debug: false, method: "sidebar_toggle_handle",                 },
      { category_key: "その他", name: "設定 / 閉じる",           trigger_type: "key",  trigger_key: ",",         if_mode: "play", if_debug: false, method: "general_setting_modal_shortcut_handle", },
      { category_key: "その他", name: "スタイル設定 / 閉じる",   trigger_type: "key",  trigger_key: "g",         if_mode: "play", if_debug: false, method: "appearance_modal_toggle_handle",        },
      { category_key: "その他", name: "アバター設定 / 閉じる",   trigger_type: "key",  trigger_key: "a",         if_mode: "play", if_debug: false, method: "avatar_input_modal_toggle_handle",      },
      { category_key: "その他", name: "ショートカットのヘルプ",  trigger_type: "key",  trigger_key: "?",         if_mode: "play", if_debug: false, method: "shortcut_modal_toggle_handle",          },
      { category_key: "その他", name: "ログ / 閉じる",           trigger_type: "key",  trigger_key: "\\",        if_mode: "play", if_debug: true,  method: "tl_modal_toggle_handle",                },
    ]
  }

  get trigger_keys() {
    return GX.ary_wrap(this.trigger_key)
  }

  showable_p(context) {
    if (this.if_debug) {
      return context.debug_mode_p
    } else {
      return true
    }
  }

  match_p(context, event) {
    if (this.if_mode === "play" && !context.play_mode_p) {
      return
    }
    if (this.if_mode === "edit" && !context.edit_mode_p) {
      return
    }
    if (this.if_debug && !context.debug_mode_p) {
      return
    }
    if (this.trigger_type === "key") {
      if (!this.trigger_keys.some(key => context.KeyboardHelper.soft_pure_key_p(event, key))) {
        return
      }
    }
    if (this.trigger_type === "code") {
      if (!this.trigger_keys.some(code => context.KeyboardHelper.pure_code_p(event, code))) {
        return
      }
    }
    return true
  }
}
