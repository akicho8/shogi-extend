<template lang="pug">
.OrderTeamOne
  .OrderTeamOneTitle.is-size-7.has-text-weight-bold.is-clickable(@click="TheOSM.state_toggle_handle")
    | {{label}}
  VueDraggable(
    tag="ul"
    :animation="200"
    group="OrderTeam"
    v-model="current_items"
    @start="start_handle"
    @end="end_handle"
    )
    template(v-for="e in current_items")
      li(:key="e.unique_key")
        .text(v-text="e.to_s")
</template>

<script>
import VueDraggable from "vuedraggable"

export default {
  props: {
    label: { type: String, required: true, },
    items: { type: Array,  required: true, },
  },
  components: {
    VueDraggable,
  },
  inject: ["TheSb", "TheOSM"],
  data() {
    return {
      current_items: this.items,
    }
  },
  watch: {
    items()         { this.current_items = this.items                },
    current_items() { this.$emit("update:items", this.current_items) },
  },
  methods: {
    start_handle() {
      this.TheSb.new_v.os_dnd_count += 1
    },
    end_handle() {
      this.TheSb.new_v.os_dnd_count -= 1
      this.TheSb.new_v.order_unit.cache_clear()
    },
  },
}
</script>

<style lang="sass">
.OrderTeamOne
  white-space: nowrap
  min-width: 4rem
  max-width: 6rem
  text-align: center
  font-size: $size-7

  ul
    margin-top: 6px // ラベルとの差
    display: flex
    gap: 6px        // 上下の差
    flex-direction: column
    height: 100%    // ← ulの下の空いた空間にdropできるようになる (超重要)

    // ドラッグ要素
    li
      background-color: $white
      border: 1px solid $grey-lighter
      border-radius: 2px
      padding: 0.25rem 0.75rem
      cursor: move
      // overflow: hidden で切ったと右のパッディングがなくなるため li に直接テキストを入れない
      .text
        line-height: 2.5
        overflow: hidden

    // 持ち上げられた元の要素
    .sortable-ghost
      opacity: 0

    // 持ち上げて動かしている要素
    .sortable-drag
      opacity: 1.0 ! important  // 1.0 にしたいが Sortable 側で 0.8 がハードコーディングされていて変更できない(FIXME)
</style>
