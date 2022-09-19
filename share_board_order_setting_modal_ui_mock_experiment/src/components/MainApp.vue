<template lang="pug">
.MainApp
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

      b-field(label="N手毎" custom-class="is-small")
        b-input(type="number" v-model.number="tegoto" :min="1" max="5")
      b-field(label="開始" custom-class="is-small")
        b-input(type="number" v-model.number="kaisi" :min="0" max="1")
  .columns
    .column(v-if="order_unit.order_state.constructor.name === 'O1State'")
      .TeamsContainer
        OrderTeamOne(:user_list.sync="order_unit.order_state.users" label="一列")
        OrderTeamOne(:user_list.sync="order_unit.watch_users" label="観戦")
    .column(v-if="order_unit.order_state.constructor.name === 'O2State'")
      .TeamsContainer
        OrderTeamOne(:user_list.sync="order_unit.order_state.teams[0]"  label="☗")
        OrderTeamOne(:user_list.sync="order_unit.watch_users" label="観戦")
        OrderTeamOne(:user_list.sync="order_unit.order_state.teams[1]"  label="☖")
    .column
      p 1手毎で1周したときの順: {{order_unit.order_state.round_users}}
      p
        | turn(-9..9):
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

import { OrderUnit } from "./models/order_unit.js"

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
      order_unit: new OrderUnit(),
      tegoto: 1,
      kaisi: 1,
    }
  },
  mounted() {
    this.order_unit.sample_set()
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
