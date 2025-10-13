<template lang="pug">
.SbOrderUi
  .columns.is-centered.is-multiline.is-variable.is-4.is-marginless
    .column.is-12
      .buttons
        .button(@click="order_unit.sample_set()") 面子セット
        .button(@click="order_unit.auto_users_set(['a', 'b', 'c', 'd', 'e'])") 初回相当
        .button(@click="order_unit.clear()") クリア
        .button(@click="order_unit.state_switch_to('to_o1_state')") 1列
        .button(@click="order_unit.state_switch_to('to_o2_state')") 2列
        //- .button(@click="order_unit.order_state.demo_set()") デモ
        .button(@click="order_unit.shuffle_all()") シャッフル
        .button(@click="order_unit.furigoma_core(Math.random() < 0.5)") 振り駒
        .button(@click="order_unit.swap_run()") 先後反転
        .button(@click="order_unit.dump_and_load()") JSON化して元に戻す(観戦者消滅)
    .column.is-4
      b-field(grouped)
        b-field(:label="`${change_per}手毎`")
          b-radio-button(v-model="change_per" :native-value="1") 1
          b-radio-button(v-model="change_per" :native-value="2") 2
        b-field(:label="`${start_color}から`")
          b-radio-button(v-model="start_color" :native-value="0") ☗
          b-radio-button(v-model="start_color" :native-value="1") ☖

      //- b-field(label="N手毎" custom-class="is-small")
      //-   b-input(type="number" v-model.number="change_per" :min="1" max="5")
      //- b-field(label="開始" custom-class="is-small")
      //-   b-input(type="number" v-model.number="start_color" :min="0" max="1")
    .column(v-if="order_unit.order_state.state_name === 'O1State'")
      .TeamContainer
        OrderTeamOne2(:items.sync="order_unit.order_state.users" label="一列")
        OrderTeamOne2(:items.sync="order_unit.watch_users" label="観戦")
    .column(v-if="order_unit.order_state.state_name === 'O2State'")
      .TeamContainer
        OrderTeamOne2(:items.sync="order_unit.order_state.teams[0]"  label="☗" ref="OrderTeamOne2")
        OrderTeamOne2(:items.sync="order_unit.watch_users" label="観戦")
        OrderTeamOne2(:items.sync="order_unit.order_state.teams[1]"  label="☖")
    .column.is-12
      p 一周するまでのおおまかな手数(1手毎換算): {{order_unit.round_size}}
      p ☗開始かつ1手毎で1周(重複なし): {{order_unit.order_state.black_start_order_uniq_users.map(e => e ? e.to_s : '?').join('')}}
      p 実際の順: {{order_unit.order_state.real_order_users(change_per, start_color).map(e => e ? e.to_s : '?').join('')}}
      p 0〜49: {{turn_test_range}}
      p inspect: {{order_unit.inspect}}
      p name_to_object_hash: {{order_unit.name_to_object_hash}}
    .column.is-12
      b-button(@click="() => $gs.p(order_unit.name_to_object_hash)") name_to_object_hash
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
import { GX } from "@/components/models/gs.js"

import { OrderUnit } from "../order_unit/order_unit.js"

// Components
import OrderTeamOne2 from "./OrderTeamOne2.vue"

export default {
  name: "SbOrderUi",
  mixins: [
  ],
  components: {
    OrderTeamOne2,
    VueDraggable,
  },
  provide() {
    return {
      TheApp: this,
    }
  },
  data() {
    return {
      order_unit: new OrderUnit(),
      change_per: 1,
      start_color: 0,
      os_dnd_count: 0,
    }
  },
  mounted() {
    this.order_unit.sample_set()
    // 操作中に変更すると SortableJS がエラーになる
    // setInterval(() => this.order_unit.dump_and_load(), 1000*3)

    setInterval(() => {
      // const el = this.$refs.OrderTeamOne2.$refs.draggable
      // console.log(el)
      // el.cancel()

      // let KEvent = new KeyboardEvent("keyup", {code: 27});
      // document.dispatchEvent(KEvent);

      // const foo = {
      //   "key": "Escape",
      //   "keyCode": 27,
      //   "which": 27,
      //   "code": "Escape",
      //   "location": 0,
      //   "altKey": false,
      //   "ctrlKey": false,
      //   "metaKey": false,
      //   "shiftKey": false,
      //   "repeat": false,
      // }
      // KeyboardEvent isValidElem

      // const doc = document.querySelector('body')
      // const doc = this.$refs.OrderTeamOne2.$refs.draggable
      // console.log(doc)
      // doc._sortable._onDrop()

      // doc.$el.dispatchEvent(new KeyboardEvent("keydown", { key: "Escape" }))
      // console.debug(1)

    }, 1000*3)

    // setInterval(() => {
    //   this.order_unit = new OrderUnit()
    //   this.order_unit.user_names_allocate(_.shuffle(["a", "b", "c", "d", "e", "f", "g"]))
    // }, 1000*3)
  },
  computed: {
    turn_test_range() {
      return GX.n_times_collect(50, turn => {
        const item = this.order_unit.turn_to_item(turn, this.change_per, this.start_color)
        return item ? item.to_s : "?"
      }).join("")
    },
  },
}
</script>

<style lang="sass">
.SbOrderUi
  word-break: break-all
  .TeamContainer
    // width: 24rem
    display: flex
.STAGE-development
  .SbOrderUi
    .columns
      .column
        border: 1px dashed blue
</style>
