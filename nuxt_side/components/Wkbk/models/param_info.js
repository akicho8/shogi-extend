import { ParamBase } from '@/components/models/param_base.js'

export class ParamInfo extends ParamBase {
  static get define() {
    return [
      { key: "article_title_display_key", type: "string",  name: "問題タイトルを表示",             defaults: { development: null, production: "display",               }, permanent: true,  relation: "ArticleTitleDisplayInfo",  input_attrs: null, desc: null, after_set: null, },
      { key: "moves_match_key",           type: "string",  name: "どこまで一致したら正解とする？", defaults: { development: null, production: "all",                   }, permanent: true,  relation: "MovesMatchInfo",           input_attrs: null, desc: null, after_set: null, },
      { key: "correct_behavior_key",      type: "string",  name: "駒操作で正解したら次に進む？",   defaults: { development: null, production: "correct_behavior_next", }, permanent: true,  relation: "CorrectBehaviorInfo",      input_attrs: null, desc: null, after_set: null, },
      { key: "viewpoint_flip_key",        type: "string",  name: "視点を反転",                     defaults: { development: null, production: "flip_off",              }, permanent: true,  relation: "ViewpointFlipInfo",        input_attrs: null, desc: null, after_set: null, },
      { key: "soldier_flop_key",          type: "string",  name: "盤上の駒を左右反転",             defaults: { development: null, production: "flop_off",              }, permanent: true,  relation: "SoldierFlopInfo",          input_attrs: null, desc: null, after_set: null, },
      { key: "appearance_theme_key",      type: "string",  name: "外観",                           defaults: { development: null, production: "is_appearance_theme_c", }, permanent: true,  relation: "AppearanceThemeInfo",      input_attrs: null, desc: null, after_set: null, },
      { key: "time_limit_func_key",       type: "string",  name: "時間制限",                       defaults: { development: null, production: "time_limit_func_on",    }, permanent: true,  relation: "TimeLimitFuncInfo",        input_attrs: null, desc: null, after_set: null, },
      { key: "time_limit_sec",            type: "integer", name: "制限秒数",                       defaults: { development: null, production: 60,                      }, permanent: true,  relation: null,                       input_attrs: null, desc: null, after_set: null, },
      { key: "auto_move_key",             type: "string",  name: "自動応手",                       defaults: { development: null, production: "auto_move_on",          }, permanent: true,  relation: "AutoMoveInfo",             input_attrs: null, desc: null, after_set: null, },
    ]
  }
}
