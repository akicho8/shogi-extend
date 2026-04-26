<template lang="pug">
.modal-card(v-if="room")
  .modal-card-head
    .modal-card-title
      | 対局履歴
  .modal-card-body
    b-table(
      :data="room.battles"
      :mobile-cards="false"
      hoverable
      paginated
      pagination-simple
      backend-pagination
      :total="room.total"
      :per-page="per"
      @page-change="page => page_change(page)"
      )

      // ID
      b-table-column(v-slot="{row}" field="id" label="ID" centered :visible="SB.debug_mode_p" header-class="id_header")
        | {{row.id}}

      // ☗☖
      template(v-for="location in SB.Location.values")
        b-table-column(v-slot="{row}" :label="location.name" :key="location.key" cell-class="memberships_cell")
          .memberships(:class="judge_key_of(row, location)")
            template(v-for="m in memberships_of(row, location)")
              span {{m.user.name}}

      // 日時
      b-table-column(v-slot="{row}" field="created_at" label="日時" centered header-class="created_at_header")
        | {{$time.format_row(row.created_at)}}

      // 手数
      b-table-column(v-slot="{row}" field="turn" label="手数" centered header-class="turn_header")
        | {{row.turn}}

      // 操作
      b-table-column(v-slot="{row}" header-class="controller_header")
        button.button.is-small(@click="load_handle(row)") 読み込み

    .box(v-if="development_p")
      pre {{room}}

  .modal-card-foot
    b-button.battle_list_modal_close_handle.has-text-weight-normal(@click="SB.battle_list_modal_close_handle" icon-left="chevron-left")
</template>

<script>
import QueryString from "query-string"
import { SafeSfen } from "@/components/models/safe_sfen.js"
import { Location } from "shogi-player/components/models/location.js"
import _ from "lodash"
import { support_child } from "../support_child.js"

export default {
  name: "SbBattleListModal",
  mixins: [support_child],
  data() {
    return {
      room: null,
      per: this.param_to_i("per", (process.env.NODE_ENV === "development") ? 1 : 50),
      page: this.param_to_i("page", 1),
    }
  },
  fetchOnServer: false,
  fetch() {
    return this.$axios.$get("/api/share_board/battle_list", {
      params: {
        room_key: this.SB.room_key,
        per: this.per,
        page: this.page,
      },
    }).then(e => this.room = e)
  },
  methods: {
    load_handle(battle) {
      this.SB.kifu_set({sfen: battle.sfen, turn: battle.turn})
    },
    page_change(page) {
      this.page = page
      this.$fetch()
    },
    memberships_of(battle, location) {
      return battle[location.key]
    },
    judge_key_of(battle, location) {
      if (battle.win_location == null) {
        return "is_draw"
      }
      if (battle.win_location.key === location.key) {
        return "is_win"
      } else {
        return "is_lose"
      }
    },
  },
}
</script>

<style lang="sass">
@import "../stylesheets/support"
.SbBattleListModal
  +modal_max_width(960px)

  .modal-card-body
    padding: 1.5rem

  .memberships_cell
    font-size: $size-7
    vertical-align: middle

    .memberships
      white-space: normal
      word-break: break-all

      display: flex
      flex-wrap: wrap
      gap: 0.25rem

      &.is_win
        font-weight: bold

  pre
    white-space: pre-wrap
    word-break: break-all

.STAGE-development
  .SbBattleListModal
    .modal-card-body, table, th, td
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
