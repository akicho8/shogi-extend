<template lang="pug">
.MainApp
  .columns.is-multiline
    .column
      b-field(custom-class="is-small")
        b-radio-button(custom-class="is-small" v-model="strategy_key" native-value="strategy1" @input="strategy_change_handle") 一列
        b-radio-button(custom-class="is-small" v-model="strategy_key" native-value="strategy2" @input="strategy_change_handle") 二列
  .columns.is-multiline
    .column
      .TeamContainer
        OrderTeamOne(team_key="member_simple" label="一列")
    .column
      template(v-for="turn in range")
        div {{test_case1(turn)}}
    .column
      .TeamContainer
        OrderTeamOne(team_key="member_black"  label="☗")
        OrderTeamOne(team_key="member_other"  label="観戦")
        OrderTeamOne(team_key="member_white"  label="☖")
    .column
      template(v-for="turn in range")
        div {{test_case2(turn)}}
</template>

<script>
import _ from "lodash"
import VueDraggable from "vuedraggable"

import { Strategy1 } from "./models/strategy1.js"
import { Strategy2 } from "./models/strategy2.js"

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
      strategy_key: "strategy1",
      member_black: [],
      member_white: [],
      member_other: [],
      member_simple: [ "a", "b", "c", "d", "e" ],
    }
  },
  methods: {
    // name をオブジェクトにして、一行のときの観戦フラグを持たせる
    // member_black, member_white を2つの配列にする
    // 2手づつの場合も検証する

    strategy_change_handle(strategy_key) {
      if (this.strategy_key === "strategy1") {
        [...this.member_black, ...this.member_white].forEach((e, i) => {
          const strategy = new Strategy2([this.member_black.length, this.member_white.length], i)
          const teams = [this.member_black, this.member_white]
          const name = teams[strategy.team_index][strategy.player_index]
          this.member_simple.push(name)
        })
        this.member_other.forEach(e => this.member_simple.push(e))
        this.member_black = []
        this.member_white = []
        this.member_other = []
      }
      if (this.strategy_key === "strategy2") {
        this.member_simple.forEach((e, i) => {
          const strategy = new Strategy1(this.member_simple.length, i)
          const name = this.member_simple[strategy.player_index]
          const list = [this.member_black, this.member_white][strategy.team_index]
          list.push(name)
        })
        this.member_simple = []
      }
    },
    s1_name(t) {
      const strategy = new Strategy1(this.member_simple.length, t)
      return this.member_simple[strategy.player_index]
    },
    test_case1(t) {
      const strategy = new Strategy1(this.member_simple.length, t)
      const name = this.member_simple[strategy.player_index]
      return [strategy.to_a, name]
    },
    test_case2(t) {
      const strategy = new Strategy2([this.member_black.length, this.member_white.length], t)
      const teams = [this.member_black, this.member_white]
      const name = teams[strategy.team_index][strategy.player_index]
      return [strategy.to_a, name]
    },
  },
  computed: {
    range() {
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
