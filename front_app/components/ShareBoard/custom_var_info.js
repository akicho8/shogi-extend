import MemoryRecord from 'js-memory-record'

export class CustomVarInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "title",           type: "string", name: "タイトル",           default: { development: null,                   production: "共有将棋盤",           }, desc: "対局時計が動作しているとき盤面下のコントローラーの表示有無", },
      { key: "sp_run_mode",     type: "string", name: "将棋盤モード",       default: { development: null,                   production: "play_mode",            }, desc: "",                                                           },
      { key: "internal_rule",   type: "string", name: "内部ルール",         default: { development: null,                   production: "strict",               }, desc: "strict or free",                                             },
      { key: "ctrl_mode",       type: "string", name: "コントローラー表示", default: { development: "is_ctrl_mode_visible", production: "is_ctrl_mode_hidden",  }, desc: "",                                                           },
      { key: "debug_mode",      type: "string", name: "デバッグモード",     default: { development: "is_debug_mode_on",     production: "is_debug_mode_off",    }, desc: "",                                                           },
      { key: "sync_mode",       type: "string", name: "同期モード",         default: { development: null,                   production: "is_sync_mode_soft",    }, desc: "",                                                           },
      { key: "yomiage_mode",    type: "string", name: "読み上げモード",     default: { development: null,                   production: "is_yomiage_mode_on",   }, desc: "",                                                           },
      { key: "sp_move_cancel",  type: "string", name: "駒移動キャンセル",   default: { development: "is_move_cancel_easy",  production: "is_move_cancel_hard",  }, desc: "",                                                           },
      { key: "avatar_king_key", type: "string", name: "アバター表示",       default: { development: "is_avatar_king_on",    production: "is_avatar_king_off",   }, desc: "",                                                           },
      { key: "shout_key",       type: "string", name: "叫びモード",         default: { development: "is_shout_off",         production: "is_shout_off",         }, desc: "",                                                           },
      { key: "guardian_mode",   type: "string", name: "守護獣モード",       default: { development: "is_guardian_mode_on",  production: "is_guardian_mode_on",  }, desc: "フォームなし。OFFなら動物は出ない",                          },
    ]
  }
}
