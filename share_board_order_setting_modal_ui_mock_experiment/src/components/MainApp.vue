<template lang="pug">
.MainApp
  .columns
    .column
      //- b-field(custom-class="is-small")
      //-   b-radio-button(custom-class="is-small" v-model="order_unit.strategy_key" native-value="o1_strategy" @input="order_unit.state_change_handle") 一列
      //-   b-radio-button(custom-class="is-small" v-model="order_unit.strategy_key" native-value="o2_strategy" @input="order_unit.state_change_handle") 二列
      .buttons
        .button(@click="order_unit.state_change_handle('to_o1_state')") 1列
        .button(@click="order_unit.state_change_handle('to_o2_state')") 2列
        .button(@click="order_unit.sample_set()") 例
        .button(@click="order_unit.clear()") 削除
        .button(@click="order_unit.order_state.demo_set()") デモ
      b-field(label="N手毎" custom-class="is-small")
        b-input(type="number" v-model="tegoto" :min="1" max="10")

  .columns
    .column(v-if="order_unit.order_state.constructor.name === 'O1State'")
      .TeamContainer
        OrderTeamOne(:user_list.sync="order_unit.order_state.users" label="一列")
    .column(v-if="order_unit.order_state.constructor.name === 'O2State'")
      .TeamContainer
        OrderTeamOne(:user_list.sync="order_unit.order_state.main_teams[0]"  label="☗")
        OrderTeamOne(:user_list.sync="order_unit.order_state.member_other"  label="観戦")
        OrderTeamOne(:user_list.sync="order_unit.order_state.main_teams[1]"  label="☖")
    .column
      p 1手毎で1周したときの順: {{order_unit.order_state.round_users}}
      p
        | turn(-9..9):
        template(v-for="turn in turn_test_range")
          | {{order_unit.current_user_by_turn(turn, tegoto)}}
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
    }
  },
  mounted() {
    this.order_unit.sample_set()
  },
  methods: {
    // name をオブジェクトにして、一行のときの観戦フラグを持たせる
    // main_teams, main_teams を2つの配列にする
    // 2手づつの場合も検証する
  },
  computed: {
    turn_test_range() {
      return [-9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    },
  },
}
</script>

<style lang="sass">
.MainApp
  .columns
    .column
      border: 1px dashed blue
  .TeamContainer
    width: 12rem
    display: flex // OrderTeamOne を横並び化
</style>
