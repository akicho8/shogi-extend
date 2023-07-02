import { ParamBase } from '@/components/models/param_base.js'

export class ParamInfo extends ParamBase {
  static get define() {
    return [
      { key: "article_title_display_key", type: "string",  name: "問題タイトルを表示",         defaults: { development: null, production: "display",    }, permanent: true,  relation: "ArticleTitleDisplayInfo",  input_attrs: null, desc: null, after_set: null, },
      { key: "moves_match_key",           type: "string",  name: "○○が一致したら正解とする", defaults: { development: null, production: "all",        }, permanent: true,  relation: "MovesMatchInfo",           input_attrs: null, desc: null, after_set: null, },
      { key: "correct_behavior_key",      type: "string",  name: "駒操作で正解したら次に",     defaults: { development: null, production: "go_to_next", }, permanent: true,  relation: "CorrectBehaviorInfo",      input_attrs: null, desc: null, after_set: null, },
      { key: "viewpoint_flip_key",        type: "string",  name: "視点を反転",                 defaults: { development: null, production: "flip_off",   }, permanent: true,  relation: "ViewpointFlipInfo",        input_attrs: null, desc: null, after_set: null, },
      { key: "soldier_flop_key",          type: "string",  name: "盤上の駒を左右反転",         defaults: { development: null, production: "flip_off",   }, permanent: true,  relation: "SoldierFlopInfo",          input_attrs: null, desc: null, after_set: null, },
    ]
  }
}
