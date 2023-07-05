const STORAGE_VERSION = 0

import { params_controller } from "@/components/params_controller.js"
import { ParamInfo         } from "../models/param_info.js"

import { ArticleTitleDisplayInfo } from "../models/article_title_display_info.js"
import { MovesMatchInfo          } from "../models/moves_match_info.js"
import { CorrectBehaviorInfo     } from "../models/correct_behavior_info.js"
import { ViewpointFlipInfo       } from "../models/viewpoint_flip_info.js"
import { SoldierFlopInfo         } from "../models/soldier_flop_info.js"
import { AutoMoveInfo         } from "../models/auto_move_info.js"

export const mod_storage = {
  mixins: [params_controller],
  data() {
    return {
      ...ParamInfo.null_value_data_hash,
    }
  },
  computed: {
    ParamInfo() { return ParamInfo },

    ls_storage_key() {
      return `WkbkBookShow/${STORAGE_VERSION}`
    },

    ArticleTitleDisplayInfo()    { return ArticleTitleDisplayInfo                                       },
    article_title_display_info() { return ArticleTitleDisplayInfo.fetch(this.article_title_display_key) },

    MovesMatchInfo()             { return MovesMatchInfo                                                },
    moves_match_info()           { return MovesMatchInfo.fetch(this.moves_match_key)                    },

    CorrectBehaviorInfo()        { return CorrectBehaviorInfo                                           },
    correct_behavior_info()      { return CorrectBehaviorInfo.fetch(this.correct_behavior_key)          },

    ViewpointFlipInfo()          { return ViewpointFlipInfo                                             },
    viewpoint_flip_info()        { return ViewpointFlipInfo.fetch(this.viewpoint_flip_key)              },

    SoldierFlopInfo()            { return SoldierFlopInfo                                               },
    soldier_flop_info()          { return SoldierFlopInfo.fetch(this.soldier_flop_key)                  },

    AutoMoveInfo()            { return AutoMoveInfo                                               },
    auto_move_info()          { return AutoMoveInfo.fetch(this.auto_move_key)                  },
  },
}
