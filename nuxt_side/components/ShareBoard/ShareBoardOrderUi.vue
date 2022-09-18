<template lang="pug">
.ShareBoardOrderUi
  .columns
    .column
      .buttons
        .button(@click="order_unit.state_change_handle('to_o1_state')") 1列
        .button(@click="order_unit.state_change_handle('to_o2_state')") 2列
        .button(@click="order_unit.sample_set()") 例
        .button(@click="order_unit.clear()") 削除
        .button(@click="order_unit.order_state.demo_set()") デモ
        .button(@click="order_unit.shuffle_core()") シャッフル
        .button(@click="order_unit.furigoma_core(Math.random() < 0.5)") 振り駒
        .button(@click="order_unit.swap_exec()") 先後反転
        .button(@click="order_unit.dump_and_load()") dump_and_load
    .column
      b-field(:label="`${tegoto}手毎`")
        b-radio-button(v-model="tegoto" :native-value="1") 1
        b-radio-button(v-model="tegoto" :native-value="2") 2
    .column
      b-field(:label="`${kaisi}から`")
        b-radio-button(v-model="kaisi" :native-value="0") ☗
        b-radio-button(v-model="kaisi" :native-value="1") ☖

      //- b-field(label="N手毎" custom-class="is-small")
      //-   b-input(type="number" v-model.number="tegoto" :min="1" max="5")
      //- b-field(label="開始" custom-class="is-small")
      //-   b-input(type="number" v-model.number="kaisi" :min="0" max="1")
  .columns
    .column(v-if="order_unit.order_state.constructor.name === 'O1State'")
      .TeamContainer
        OrderTeamOne(:user_list.sync="order_unit.order_state.users" label="一列")
        OrderTeamOne(:user_list.sync="order_unit.member_other" label="観戦")
    .column(v-if="order_unit.order_state.constructor.name === 'O2State'")
      .TeamContainer
        OrderTeamOne(:user_list.sync="order_unit.order_state.teams[0]"  label="☗")
        OrderTeamOne(:user_list.sync="order_unit.member_other" label="観戦")
        OrderTeamOne(:user_list.sync="order_unit.order_state.teams[1]"  label="☖")
    .column
      p ☗開始かつ1手毎で1周(重複なし): {{order_unit.order_state.black_start_order_uniq_users}}
      p 実際の順: {{order_unit.order_state.real_order_users(tegoto, kaisi)}}
      p 必ず全員が含まれる容量(1手毎換算): {{order_unit.round_size}}
      p
        | ターン0〜7: 
        template(v-for="turn in turn_test_range")
          | {{order_unit.current_user_by_turn(turn, tegoto, kaisi)}}
  .columns
    .column
      pre
        | {{order_unit}}
    .column
      pre
        | {{order_unit.attributes}}
</template>

<script>
import _ from "lodash"
import VueDraggable from "vuedraggable"

import { OrderUnit } from "./models/order_unit/order_unit.js"

// Components
import OrderTeamOne from "./OrderTeamOne.vue"

export default {
  name: "ShareBoardOrderUi",
  mixins: [
  ],
  components: {
    OrderTeamOne,
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
      kaisi: 0,
    }
  },
  mounted() {
    // this.order_unit.sample_set()
  },
  computed: {
    turn_test_range() {
      return [0, 1, 2, 3, 4, 5, 6, 7]
    },
  },
}
</script>

<style lang="sass">
.ShareBoardOrderUi
  .columns
    .column
      border: 1px dashed blue
  .TeamContainer
    width: 12rem
    display: flex // OrderTeamOne を横並び化
</style>
