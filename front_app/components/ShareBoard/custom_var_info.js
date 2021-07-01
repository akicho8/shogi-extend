import MemoryRecord from 'js-memory-record'

export class CustomVarInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "title",                type: "string",  name: "タイトル",                      default: { development: null,                   production: "共有将棋盤",              }, desc: "対局時計が動作しているとき盤面下のコントローラーの表示有無", },
      { key: "sp_run_mode",          type: "string",  name: "将棋盤モード",                  default: { development: null,                   production: "play_mode",               }, desc: "",                                                           },
      { key: "sp_internal_rule_key", type: "string",  name: "内部ルール",                    default: { development: null,                   production: "is_internal_rule_strict", }, desc: "",                                             },
      { key: "ctrl_mode_key",        type: "string",  name: "コントローラー表示",            default: { development: "is_ctrl_mode_visible", production: "is_ctrl_mode_hidden",     }, desc: "",                                                           },
      { key: "debug_mode_key",       type: "string",  name: "デバッグモード",                default: { development: "is_debug_mode_on",     production: "is_debug_mode_off",       }, desc: "",                                                           },
      { key: "yomiage_mode_key",     type: "string",  name: "読み上げモード",                default: { development: null,                   production: "is_yomiage_mode_on",      }, desc: "",                                                           },
      { key: "sp_move_cancel",       type: "string",  name: "駒移動キャンセル",              default: { development: "is_move_cancel_easy",  production: "is_move_cancel_hard",     }, desc: "",                                                           },
      { key: "move_guard_key",       type: "string",  name: "操作制限",                      default: { development: null,                   production: "is_move_guard_on",        }, desc: "",                                                           },
      { key: "avatar_king_key",      type: "string",  name: "アバター表示",                  default: { development: "is_avatar_king_off",   production: "is_avatar_king_off",      }, desc: "",                                                           },
      { key: "shout_mode_key",       type: "string",  name: "叫びモード",                    default: { development: "is_shout_mode_off",    production: "is_shout_mode_off",       }, desc: "",                                                           },
      { key: "guardian_mode",        type: "string",  name: "守護獣モード",                  default: { development: "is_guardian_mode_off", production: "is_guardian_mode_on",     }, desc: "フォームなし。OFFなら動物は出ない",                          },
      { key: "xmatch_wait_max",      type: "integer", name: "待ち時間最大",                  default: { development: null,                  production: 60 * 3,                    }, desc: null, },
      { key: "xmatch_redis_ttl",     type: "integer", name: "マッチングエントリ度の更新TTL", default: { development: null,                  production: 60 * 3 + 3,                }, desc: null, },
      { key: "xmatch_auth_key",      type: "string",  name: "ルール選択時に認証方法",        default: { development: null,                  production: "handle_name_required",    }, desc: null, },
    ]
  }
}
