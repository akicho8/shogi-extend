<template lang="pug">
.SbDashboardUserRanking.box(v-if="$gs.present_p(TheDb.info.roomships)")
  .title ランキング
  b-table.SbDashboardUserRanking(
    :data="TheDb.info.roomships"
    :paginated="false"
    :per-page="10"
    :mobile-cards="false"
    default-sort-direction="desc"
    )
    b-table-column(v-slot="{row}" field="rank" label="順位" sortable numeric centered :width="1")
      | {{row.rank}}
    b-table-column(v-slot="{row}" field="user.name" label="棋士")
      | {{row.user.name}}
    b-table-column(v-slot="{row}" field="win_count" label="勝" sortable numeric centered :width="1")
      | {{row.win_count}}
    b-table-column(v-slot="{row}" field="lose_count" label="負" sortable numeric centered :width="1")
      | {{row.lose_count}}
    b-table-column(v-slot="{row}" field="win_rate" label="勝率" sortable numeric centered :width="1")
      span(:class="{'has-text-weight-bold': win_rate_good_p(row.win_rate)}")
        | {{win_rate_cast(row.win_rate)}}
    b-table-column(v-slot="{row}" field="battles_count" label="対局数" sortable numeric centered :width="1" :visible="development_p")
      | {{row.battles_count}}
    b-table-column(v-slot="{row}" field="score" label="点数" sortable numeric centered :width="1" :visible="development_p")
      | {{row.score}}
</template>

<script>
import QueryString from "query-string"
import { SafeSfen } from "@/components/models/safe_sfen.js"
import { Location } from "shogi-player/components/models/location.js"
import _ from "lodash"
import { support_child } from "../support_child.js"

export default {
  name: "SbDashboardBody",
  mixins: [support_child],
  inject: ["TheDb"],
  methods: {
    win_rate_cast(value) {
      return value.toFixed(3)
    },
    win_rate_good_p(value) {
      return value >= 0.5
    },
  },
}
</script>

<style lang="sass">
@import "../sass/support.sass"
.SbDashboardUserRanking
  __css_keep__: 0
</style>
