import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import _ from "lodash"
import { GX } from "@/components/models/gx.js"

import { Location } from "shogi-player/components/models/location.js"
import { IllegalInfo } from "shogi-player/components/models/illegal_info.js"
import { RoleGroup } from "../mod_role/role_group.js"

export class EndingRouteTestInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "詰み(勝者)",      ending_route_key: "er_auto_checkmate",      win_location_key: "black", my_location_key: "black", finished_user_name: "(b2)", illegal_keys: [],                                                },
      { key: "詰み(敗者)",      ending_route_key: "er_auto_checkmate",      win_location_key: "black", my_location_key: "white", finished_user_name: "(b2)", illegal_keys: [],                                                },
      { key: "詰み(観戦者)",    ending_route_key: "er_auto_checkmate",      win_location_key: "black", my_location_key: null,    finished_user_name: "(b2)", illegal_keys: [],                                                },
      { key: "投了1",           ending_route_key: "er_user_normal_resign",  win_location_key: "black", my_location_key: "black", resigned_user_name: "(w1)", illegal_keys: [],                                                },
      { key: "反則からの投了1", ending_route_key: "er_user_illegal_resign", win_location_key: "black", my_location_key: "black", resigned_user_name: "(w1)", choker_user_name: "(w2)", illegal_keys: ["illegal_double_pawn", "illegal_pawn_drop_mate"], },
      { key: "反則1",           ending_route_key: "er_auto_illegal",        win_location_key: "black", my_location_key: "black", choker_user_name: "(w2)", illegal_keys: ["illegal_double_pawn"], },
      { key: "時間切れ1",       ending_route_key: "er_self_timeout",        win_location_key: "black", my_location_key: "black", choker_user_name: "(w2)", },
      { key: "引き分け1",       ending_route_key: "er_auto_draw",           win_location_key: null,    my_location_key: "black", },
    ]
  }

  get illegal_hv_list() {
    return (this.illegal_keys ?? []).map(e => {
      return { illegal_info: IllegalInfo.fetch(e) }
    })
  }

  get role_group_attributes() {
    return {
      black: ["(b1)", "(b2)"],
      white: ["(w1)", "(w2)"],
    }
  }

  get ending_context_params() {
    return {
      // 共通
      win_location_key:      this.win_location_key,
      ending_route_key:      this.ending_route_key,
      role_group_attributes: this.role_group_attributes,
      illegal_hv_list:       this.illegal_hv_list,
      finished_user_name:    this.finished_user_name,
      resigned_user_name:    this.resigned_user_name,
      choker_user_name:      this.choker_user_name,
      // 各自で異なる
      my_location_key:       this.my_location_key,
    }
  }
}
