import { ParamBase } from '@/components/models/param_base.js'

export class ParamInfo extends ParamBase {
  static get define() {
    return [
      { key: "title",                type: "string",  name: "タイトル",                      defaults: { development: null,                      production: "共有将棋盤",                  }, permanent: false, relation: null,                  desc: null, },
      { key: "sp_run_mode",          type: "string",  name: "将棋盤モード",                  defaults: { development: null,                      production: "play_mode",                   }, permanent: false, relation: null,                  desc: null, },
      { key: "yomiage_mode_key",     type: "string",  name: "読み上げモード",                defaults: { development: null,                      production: "is_yomiage_mode_on",          }, permanent: true,  relation: "YomiageModeInfo",     desc: null, },
      { key: "guardian_display_key", type: "string",  name: "守護獣表示",                    defaults: { development: null,                      production: "is_guardian_display_on",      }, permanent: false, relation: "GuardianDisplayInfo", desc: null, },
      { key: "sp_internal_rule_key", type: "string",  name: "内部ルール",                    defaults: { development: null,                      production: "is_internal_rule_strict",     }, permanent: false, relation: "SpInternalRuleInfo",  desc: null, },
      { key: "color_theme_key",      type: "string",  name: "画像の配色",                    defaults: { development: null,                      production: "is_color_theme_real",         }, permanent: true,  relation: "ColorThemeInfo",      desc: null, },
      { key: "appearance_theme_key", type: "string",  name: "基本配色",                      defaults: { development: null,                      production: "is_appearance_theme_a",       }, permanent: true,  relation: "AppearanceThemeInfo", desc: null, },
      { key: "ctrl_mode_key",        type: "string",  name: "コントローラー表示",            defaults: { development: "is_ctrl_mode_visible",    production: "is_ctrl_mode_hidden",         }, permanent: false, relation: "CtrlModeInfo",        desc: null, },
      { key: "debug_mode_key",       type: "string",  name: "デバッグモード",                defaults: { development: "is_debug_mode_on",        production: "is_debug_mode_off",           }, permanent: false, relation: "DebugModeInfo",       desc: null, },
      { key: "sp_move_cancel_key",   type: "string",  name: "駒移動キャンセル",              defaults: { development: "is_move_cancel_standard", production: "is_move_cancel_standard",     }, permanent: true,  relation: "SpMoveCancelInfo",    desc: null, },

      { key: "move_guard_key",       type: "string",  name: "操作制限",                      defaults: { development: null,                      production: "is_move_guard_on",            }, permanent: false, relation: "MoveGuardInfo",       desc: null, },
      { key: "avatar_king_key",      type: "string",  name: "玉をアバターにする",            defaults: { development: null,                      production: "is_avatar_king_off",          }, permanent: true,  relation: "AvatarKingInfo",      desc: null, },
      { key: "shout_mode_key",       type: "string",  name: "叫びモード",                    defaults: { development: null,                      production: "is_shout_mode_off",           }, permanent: false, relation: "ShoutModeInfo",       desc: null, },
      { key: "foul_behavior_key",    type: "string",  name: "反則制限モード",                defaults: { development: null,                      production: "is_foul_behavior_auto",       }, permanent: true,  relation: "FoulBehaviorInfo",    desc: null, },
      { key: "tegoto",               type: "integer", name: "N手毎交代",                     defaults: { development: null,                      production: 1,                             }, permanent: false, relation: null,                  desc: null, },

      { key: "board_width",          type: "float",   name: "盤の大きさ",                    defaults: { development: null,                      production: 80.0,                          }, permanent: true,  relation: null,                  desc: null, },
      { key: "message_scope_key",    type: "string",  name: "発言スコープ",                  defaults: { development: null,                      production: "is_message_scope_public",     }, permanent: false, relation: "MessageScopeInfo",    desc: null, },
      { key: "image_size_key",       type: "string",  name: "ダウンロード画像サイズ",        defaults: { development: null,                      production: "is_image_size_1920x1080",     }, permanent: true,  relation: "ImageSizeInfo",       desc: null, },
      { key: "board_preset_key",     type: "string",  name: "手合割",                        defaults: { development: null,                      production: "平手",                        }, permanent: true,  relation: "BoardPresetInfo",     desc: null, },
      { key: "quick_sync_key",       type: "string",  name: "同期タイミング",                defaults: { development: null,                      production: "is_quick_sync_on",            }, permanent: false, relation: "QuickSyncInfo",       desc: null, },
      { key: "faul_caution_key",     type: "string",  name: "反則時の自動注意",              defaults: { development: null,                      production: "is_caution_on",               }, permanent: false, relation: null,                  desc: null, },
      { key: "fixed_order_names",    type: "string",  name: "順番設定の順番",                defaults: { development: null,                      production: "",                            }, permanent: false, relation: null,                  desc: null, },
      { key: "fixed_order_state",    type: "string",  name: "順番設定の方法",                defaults: { development: null,                      production: "to_o2_state",                 }, permanent: false, relation: null,                  desc: null, },
      { key: "order_enable_p",       type: "boolean", name: "順番設定が有効か？",            defaults: { development: null,                      production: false,                         }, permanent: false, relation: null,                  desc: null, },
      { key: "auto_close_p",         type: "boolean", name: "自動的に閉じるか？",            defaults: { development: false,                     production: true,                          }, permanent: false, relation: null,                  desc: null, },

      { key: "xmatch_wait_max",      type: "integer", name: "待ち時間最大",                  defaults: { development: null,                      production: 60 * 3,                        }, permanent: false, relation: null,                  desc: null, },
      { key: "xmatch_redis_ttl",     type: "integer", name: "マッチングエントリ度の更新TTL", defaults: { development: null,                      production: 60 * 3 + 3,                    }, permanent: false, relation: null,                  desc: null, },
      { key: "xmatch_auth_key",      type: "string",  name: "ルール選択時に認証方法",        defaults: { development: null,                      production: "handle_name_required",        }, permanent: false, relation: "XmatchAuthInfo",      desc: null, },

    ]
  }
}
