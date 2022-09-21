<template lang="pug">
.ShareBoardOrderUi
  .columns.is-centered.is-multiline.is-variable.is-4.is-marginless
    .column.is-12
      .buttons
        .button(@click="order_unit.sample_set()") 面子セット
        .button(@click="order_unit.clear()") クリア
        .button(@click="order_unit.state_change_handle('to_o1_state')") 1列
        .button(@click="order_unit.state_change_handle('to_o2_state')") 2列
        //- .button(@click="order_unit.order_state.demo_set()") デモ
        .button(@click="order_unit.shuffle_core()") シャッフル
        .button(@click="order_unit.furigoma_core(Math.random() < 0.5)") 振り駒
        .button(@click="order_unit.swap_run()") 先後反転
        .button(@click="order_unit.dump_and_load()") JSON化して元に戻す(観戦者消滅)
    .column.is-4
      b-field(grouped)
        b-field(:label="`${tegoto}手毎`")
          b-radio-button(v-model="tegoto" :native-value="1") 1
          b-radio-button(v-model="tegoto" :native-value="2") 2
        b-field(:label="`${start_color}から`")
          b-radio-button(v-model="start_color" :native-value="0") ☗
          b-radio-button(v-model="start_color" :native-value="1") ☖

      //- b-field(label="N手毎" custom-class="is-small")
      //-   b-input(type="number" v-model.number="tegoto" :min="1" max="5")
      //- b-field(label="開始" custom-class="is-small")
      //-   b-input(type="number" v-model.number="start_color" :min="0" max="1")
    .column(v-if="order_unit.order_state.constructor.name === 'O1State'")
      .TeamContainer
        OrderTeamOne2(:user_list.sync="order_unit.order_state.users" label="一列")
        OrderTeamOne2(:user_list.sync="order_unit.watch_users" label="観戦")
    .column(v-if="order_unit.order_state.constructor.name === 'O2State'")
      .TeamContainer
        OrderTeamOne2(:user_list.sync="order_unit.order_state.teams[0]"  label="☗")
        OrderTeamOne2(:user_list.sync="order_unit.watch_users" label="観戦")
        OrderTeamOne2(:user_list.sync="order_unit.order_state.teams[1]"  label="☖")
    .column.is-12
      p 一周するまでのおおまかな手数(1手毎換算): {{order_unit.round_size}}
      p ☗開始かつ1手毎で1周(重複なし): {{order_unit.order_state.black_start_order_uniq_users.map(e => e ? e.to_s : '?').join('')}}
      p 実際の順: {{order_unit.order_state.real_order_users(tegoto, start_color).map(e => e ? e.to_s : '?').join('')}}
      p 0〜49: {{turn_test_range}}
    .column.is-6
      p stringify
      pre
        | {{order_unit}}
    .column.is-6
      p attributes
      pre
        | {{order_unit.attributes}}
</template>

<script>
import _ from "lodash"
import VueDraggable from "vuedraggable"
import { Gs2 } from "@/components/models/gs2.js"

import { OrderUnit } from "../order_unit/order_unit.js"

// Components
import OrderTeamOne2 from "./OrderTeamOne2.vue"

export default {
  name: "ShareBoardOrderUi",
  mixins: [
  ],
  components: {
    OrderTeamOne2,
    VueDraggable,
  },
  provide() {
    return {
      base: this,
    }
  },
  data() {
    return {
      order_unit: new OrderUnit(),
      tegoto: 1,
      start_color: 0,
    }
  },
  mounted() {
    this.order_unit.sample_set()
    // 操作中に変更すると SortableJS がエラーになる
    // setInterval(() => this.order_unit.dump_and_load(), 1000*3)
  },
  computed: {
    turn_test_range() {
      return Gs2.n_times_collect(50, turn => {
        const item = this.order_unit.turn_to_item(turn, this.tegoto, this.start_color)
        return item ? item.to_s : "?"
      }).join("")
    },
  },
}
</script>

<style lang="sass">
.ShareBoardOrderUi
  word-break: break-all
  .TeamContainer
    // width: 24rem
    display: flex
.STAGE-development
  .ShareBoardOrderUi
    .columns
      .column
        border: 1px dashed blue
</style>
