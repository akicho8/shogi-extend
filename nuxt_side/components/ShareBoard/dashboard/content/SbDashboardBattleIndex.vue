<template lang="pug">
.SbDashboardBattleIndex.box(v-if="$GX.present_p(TheDb.info.latest_battles)")
  .title 対局履歴(直近{{TheDb.info.latest_battles_max}}件)
  b-table(
    :data="TheDb.info.latest_battles"
    :mobile-cards="false"
    )
    // ☗☖
    template(v-for="location in Location.values")
      b-table-column(v-slot="{row}" :label="location.name" :key="location.key" cell-class="memberships_cell")
        .memberships(:class="judge_key_of(row, location)")
          template(v-for="m in memberships_of(row, location)")
            span {{m.user.name}}
    // 日時
    b-table-column(v-slot="{row}" field="created_at" label="日時" sortable centered :width="1")
      | {{$time.format_row(row.created_at)}}

    // 棋譜
    b-table-column(v-slot="{row}" centered)
      a(:href="sb_path(row)" target="_blank") 棋譜
</template>

<script>
import QueryString from "query-string"
import { SafeSfen } from "@/components/models/safe_sfen.js"
import { Location } from "shogi-player/components/models/location.js"
import _ from "lodash"
import { support_child } from "./support_child.js"

export default {
  name: "SbDashboardBody",
  mixins: [support_child],
  inject: ["TheDb"],
  methods: {
    sb_path(row) {
      return QueryString.stringifyUrl({
        url: `/share-board`,
        query: {
          xbody: SafeSfen.encode(row.sfen),
          ...this.black_white(row),
        },
      })
    },
    // {black: 'a,b', white: 'c,d'}
    black_white(row) {
      return Location.values.reduce((a, e) => {
        return {...a, [e.key]: row[e.key].map(e => e.user.name).join(",")}
      }, {})
    },
    memberships_of(row, location) {
      // return row.memberships.filter(e => e.location.key === location.key)
      return row[location.key]
    },
    judge_key_of(row, location) {
      if (row.win_location == null) {
        return "is_draw"
      }
      if (row.win_location.key === location.key) {
        return "is_win"
      } else {
        return "is_lose"
      }
    },
  },
  computed: {
    Location() { return Location },
  },
}
</script>

<style lang="sass">
@import "../../sass/support.sass"
.SbDashboardBattleIndex
  .memberships_cell
    font-size: $size-7
    vertical-align: middle

    .memberships
      white-space: normal
      word-break: break-all

      display: flex
      flex-wrap: wrap
      gap: 0.5rem

      &.is_win
        font-weight: bold
</style>
