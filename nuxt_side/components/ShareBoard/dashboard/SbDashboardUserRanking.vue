<template lang="pug">
.SbDashboardUserRanking.box(v-if="$gs.present_p(TheDb.info.roomships)")
  .title ランキング
  b-table.SbDashboardUserRanking(
    :data="TheDb.info.roomships"
    :paginated="false"
    :per-page="10"
    :mobile-cards="false"
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
      | {{win_rate_cast(row.win_rate)}}
    b-table-column(v-slot="{row}" field="battles_count" label="対局数" sortable numeric centered :width="1" :visible="development_p")
      | {{row.battles_count}}
    b-table-column(v-slot="{row}" field="score" label="点数" sortable numeric centered :width="1" :visible="development_p")
      | {{row.score}}
</template>

<script>
const QueryString = require("query-string")
import { SafeSfen } from "@/components/models/safe_sfen.js"
import { Location } from "shogi-player/components/models/location.js"
import _ from "lodash"

export default {
  name: "SbDashboardBody",
  inject: ["TheDb"],
  methods: {
    win_rate_cast(value) {
      return value.toFixed(3)
    },
  },
  computed: {
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.SbDashboardUserRanking
</style>
