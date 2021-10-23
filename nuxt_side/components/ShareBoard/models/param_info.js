import { ParamBase } from '@/components/models/param_base.js'

export class ParamInfo extends ParamBase {
  static get define() {
    return [
      { key: "share_board_column_width", type: "float",   name: "盤の大きさ",                    defaults: { development: null,                   production: 80.0,                          }, permanent: true,  relation: null,             desc: null,           },
      { key: "title",                    type: "string",  name: "タイトル",                      defaults: { development: null,                   production: "共有将棋盤",                  }, permanent: false, relation: null,                 desc: "対局時計が動作しているとき盤面下のコントローラーの表示有無",   },
      { key: "sp_run_mode",              type: "string",  name: "将棋盤モード",                  defaults: { development: null,                   production: "play_mode",                   }, permanent: false, relation: null,                 desc: null,                                                           },
      { key: "move_guard_key",           type: "string",  name: "操作制限",                      defaults: { development: null,                   production: "is_move_guard_on",            }, permanent: false, relation: "MoveGuardInfo",      desc: null,                                                           },
      { key: "yomiage_mode_key",         type: "string",  name: "読み上げモード",                defaults: { development: null,                   production: "is_yomiage_mode_on",          }, permanent: false, relation: "YomiageModeInfo",    desc: null,                                                           },
      { key: "guardian_mode",            type: "string",  name: "守護獣表示",                    defaults: { development: null,                   production: "is_guardian_mode_on",         }, permanent: false, relation: null,                 desc: "組み込み機能の有効化",                          },
      { key: "xmatch_wait_max",          type: "integer", name: "待ち時間最大",                  defaults: { development: null,                   production: 60 * 3,                        }, permanent: false, relation: null,                 desc: null, },
      { key: "xmatch_redis_ttl",         type: "integer", name: "マッチングエントリ度の更新TTL", defaults: { development: null,                   production: 60 * 3 + 3,                    }, permanent: false, relation: null,                 desc: null, },
      { key: "xmatch_auth_key",          type: "string",  name: "ルール選択時に認証方法",        defaults: { development: null,                   production: "handle_name_required",        }, permanent: false, relation: "XmatchAuthInfo",     desc: null, },
      { key: "sp_internal_rule_key",     type: "string",  name: "内部ルール",                    defaults: { development: null,                   production: "is_internal_rule_strict",     }, permanent: false, relation: "SpInternalRuleInfo", desc: null,                                                           },
      { key: "color_theme_key",          type: "string",  name: "配色",                          defaults: { development: null,                   production: "is_color_theme_paper_simple", }, permanent: true,  relation: "ColorThemeInfo",     desc: null,           },
      { key: "ctrl_mode_key",            type: "string",  name: "コントローラー表示",            defaults: { development: "is_ctrl_mode_visible", production: "is_ctrl_mode_hidden",         }, permanent: false, relation: "CtrlModeInfo",       desc: null,                                                           },
      { key: "debug_mode_key",           type: "string",  name: "デバッグモード",                defaults: { development: "is_debug_mode_on",     production: "is_debug_mode_off",           }, permanent: false, relation: "DebugModeInfo",      desc: null,                                                           },
      { key: "sp_move_cancel",           type: "string",  name: "駒移動キャンセル",              defaults: { development: "is_move_cancel_easy",  production: "is_move_cancel_hard",         }, permanent: true,  relation: "SpMoveCancelInfo",   desc: null,                                                           },
      { key: "avatar_king_key",          type: "string",  name: "玉をアバターにする",            defaults: { development: null,                   production: "is_avatar_king_off",          }, permanent: false, relation: "AvatarKingInfo",     desc: null,                                                           },
      { key: "shout_mode_key",           type: "string",  name: "叫びモード",                    defaults: { development: null,                   production: "is_shout_mode_off",           }, permanent: false, relation: "ShoutModeInfo",      desc: null,                                                           },
    ]
  }
}
