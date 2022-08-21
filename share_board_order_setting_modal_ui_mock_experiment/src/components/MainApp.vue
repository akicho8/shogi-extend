<template lang="pug">
.MainApp
  .columns.is-multiline
    .column
      .GroupContainer
        OrderGroupOne(group_key="member_rows1" position="is_position_left"   label="☗")
        OrderGroupOne(group_key="member_rows2" position="is_position_right"  label="☖")
        OrderGroupOne(group_key="member_rows3" position="is_position_bottom" label="観戦")
</template>

<script>
import _ from "lodash"
import VueDraggable from "vuedraggable"

// Components
import OrderGroupOne from "./OrderGroupOne.vue"

export default {
  mixins: [
  ],
  components: {
    OrderGroupOne,
    VueDraggable,
  },
  provide() {
    return {
      base: this,
    }
  },
  data() {
    return {
      member_rows1: [
        { user_name: "a01234567890123456789", },
        { user_name: "あいうえお", },
        { user_name: "きん", },
        { user_name: "abcdef", },
      ],
      member_rows2: [
        { user_name: "b01234567890123456789", },
        { user_name: "b1", },
        { user_name: "b2", },
      ],
      member_rows3: [
        { user_name: "c01234567890123456789", },
        { user_name: "c1", },
      ],
    }
  },
  methods: {
    junban() {
    },
  },
}
</script>

<style lang="sass">
.MainApp
  .columns
    .column
      border: 1px dashed blue
  .GroupContainer
    width: 12rem
    display: flex // OrderGroupOne を横並び化
</style>
