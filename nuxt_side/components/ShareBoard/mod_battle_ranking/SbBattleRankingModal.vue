<template lang="pug">
.modal-card(v-if="room")
  .modal-card-head
    .modal-card-title
      | ランキング
  .modal-card-body
    template(v-if="$GX.blank_p(room.roomships)")
      p この部屋では一度も対局していません
    template(v-else)
      b-table(
        :data="room.roomships"
        :mobile-cards="false"
        )

        b-table-column(v-slot="{row}" field="id" label="ID" centered :visible="SB.debug_mode_p")
          | {{row.id}}

        b-table-column(v-slot="{row}" field="rank" label="順位" sortable numeric centered)
          | {{row.rank}}

        b-table-column(v-slot="{row}" field="user.name" label="名前")
          span.user_name(:class="name_class(row)")
            | {{row.user.name}}

        b-table-column(v-slot="{row}" field="win_rate" label="勝率" sortable numeric centered)
          | {{win_rate_cast(row.win_rate)}}

        b-table-column(v-slot="{row}" field="win_count" label="勝" sortable numeric centered)
          | {{row.win_count}}

        b-table-column(v-slot="{row}" field="lose_count" label="負" sortable numeric centered)
          | {{row.lose_count}}

        b-table-column(v-slot="{row}" field="draw_count" label="分" sortable numeric centered)
          | {{row.draw_count}}

        b-table-column(v-slot="{row}" field="battles_count" label="対局数" sortable numeric centered :visible="SB.debug_mode_p")
          | {{row.battles_count}}

        b-table-column(v-slot="{row}" field="score" label="点数" sortable numeric centered :visible="SB.debug_mode_p")
          | {{row.score}}

    pre.pre-wrap(v-if="SB.debug_mode_p && false") {{room}}

  .modal-card-foot
    b-button.battle_ranking_modal_close_handle.has-text-weight-normal(@click="SB.battle_ranking_modal_close_handle" icon-left="chevron-left")
</template>

<script>
import _ from "lodash"
import { support_child } from "../support_child.js"
import { AppConfig } from "../models/app_config.js"

export default {
  name: "SbBattleRankingModal",
  mixins: [support_child],
  data() {
    return {
      room: null,
    }
  },
  fetchOnServer: false,
  fetch() {
    return this.$axios.$get("/api/share_board/battle_ranking", {
      params: {
        room_key: this.SB.room_key,
      },
    }).then(e => this.room = e)
  },
  methods: {
    win_rate_cast(value) {
      return value.toFixed(3)
    },
    name_class(roomship) {
      if (roomship.user.name === this.SB.user_name) {
        return "active_name"
      }
    },
  },
}
</script>

<style lang="sass">
@import "../stylesheets/support"
.SbBattleRankingModal
  .modal-card-body
    padding: 1rem

  .table-wrapper
    margin: 0

  table
    th
      font-size: $size-7
      .sort-icon
        display: none

    th, td
      vertical-align: middle    // bulma のデフォルトが上寄りなので中央に戻す

    .active_name
      font-weight: bold

.STAGE-development-x
  .SbBattleRankingModal
    .modal-card-body, table, th, td
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
