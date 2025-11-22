<template lang="pug">
.MainApp
  .columns
    .column
      .buttons
        .button(@click="order_flow.operation_change('to_v1_operation')") 1列
        .button(@click="order_flow.operation_change('to_v2_operation')") 2列
        .button(@click="order_flow.sample_set()") 例
        .button(@click="order_flow.clear()") 削除
        .button(@click="order_flow.order_operation.demo_set()") デモ
        .button(@click="order_flow.shuffle_all()") シャッフル
        .button(@click="order_flow.furigoma_core(Math.random() < 0.5)") 振り駒
        .button(@click="order_flow.swap_exec()") 先後反転
        .button(@click="order_flow.dump_and_load()") dump_and_load

      b-field(label="N手毎" custom-class="is-small")
        b-input(type="number" v-model.number="change_per" :min="1" max="5")
      b-field(label="開始" custom-class="is-small")
        b-input(type="number" v-model.number="scolor" :min="0" max="1")
  .columns
    .column(v-if="order_flow.order_operation.constructor.name === 'V1Operation'")
      .TeamsContainer
        OrderTeamOne(:user_list.sync="order_flow.order_operation.users" label="一列")
        OrderTeamOne(:user_list.sync="order_flow.watch_users" label="観戦")
    .column(v-if="order_flow.order_operation.constructor.name === 'V2Operation'")
      .TeamsContainer
        OrderTeamOne(:user_list.sync="order_flow.order_operation.teams[0]"  label="☗")
        OrderTeamOne(:user_list.sync="order_flow.watch_users" label="観戦")
        OrderTeamOne(:user_list.sync="order_flow.order_operation.teams[1]"  label="☖")
    .column
      p 1手毎で1周したときの順: {{order_flow.order_operation.round_users}}
      p
        | turn(-9..9):
        template(v-for="turn in turn_test_range")
          | {{order_flow.current_user_by_turn(turn, change_per, scolor)}}
  .columns
    .column
      pre
        | {{order_flow}}
    .column
      pre
        | {{order_flow.attributes}}
</template>

<script>
import _ from "lodash"
import VueDraggable from "vuedraggable"

import { OrderFlow } from "./models/order_flow.js"

// Components
import OrderTeamOne from "./OrderTeamOne.vue"

export default {
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
      order_flow: new OrderFlow(),
      change_per: 1,
      scolor: 1,
    }
  },
  mounted() {
    this.order_flow.sample_set()
  },
  methods: {
    // name をオブジェクトにして、一行のときの観戦フラグを持たせる
    // teams, teams を2つの配列にする
    // 2手づつの場合も検証する
  },
  computed: {
    turn_test_range() {
      // return [-9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
      return [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    },
  },
}
</script>

<style lang="sass">
.MainApp
  .columns
    .column
      border: 1px dashed blue
  .TeamsContainer
    display: flex
    justify-content: center
</style>
