<template lang="pug">
.OrderTeamOne2
  //- ghostClass="ghost_element"
  //- @start="event_check"
  .OrderTeamOne2Title.is-size-7.has-text-weight-bold
    | {{label}}{{TheApp.os_dnd_count}}
  VueDraggable(
    tag="ul"
    :animation="200"
    group="OrderTeam"
    v-model="current_items"
    ref="draggable"
    @start="TheApp.os_dnd_count += 1"
    @end="end_handle"
    )
    template(v-for="e in current_items")
      li(:key="e.unique_key")
        | {{e.to_s}}({{e.unique_key}})
</template>

<script>
import VueDraggable from "vuedraggable"

export default {
  props: {
    items: { type: Array,   required: true,  },
    label: { type: String,  required: true,  },
  },
  components: {
    VueDraggable,
  },
  inject: ["TheApp"],
  data() {
    return {
      current_items: this.items,
    }
  },
  watch: {
    items() {
      this.current_items = this.items
    },
    current_items() {
      this.$emit("update:items", this.current_items)
    },
  },
  methods: {
    end_handle() {
      this.TheApp.os_dnd_count -= 1
      this.TheApp.order_unit.cache_clear()
    },
  },
}
</script>

<style lang="sass">
.OrderTeamOne2
  overflow: hidden
  white-space: nowrap
  min-width: 4rem
  max-width: 6rem
  text-align: center
  border: 1px border $grey-light
  font-size: $size-7

  .OrderTeamOne2Title
    // border: 1px dashed change_color(blue, $alpha: 0.5)
  ul
    display: flex
    gap: 2px
    flex-direction: column

    // border: 1px dashed change_color(red, $alpha: 0.5)
    height: 100% // ← 超重要。ulの下の空いた空間にdropできるようになる
    cursor: move

    // 名前の一つ
    li
      // border: 1px dashed change_color(blue, $alpha: 0.5)
      background-color: $white-ter
      border-radius: 4px
      line-height: 1.5
      padding: 0.25rem 0.5rem

    // 持ち上げられた元の要素
    .sortable-ghost
      opacity: 0.5
      // .ghost_element
      // opacity: 0.1

    // 持ち上げて動かしている要素
    .sortable-drag
      overflow: hidden
      opacity: 1.0 ! important  // ← 効かない
      // background-color: $white-ter
      // // border: 1px solid $grey-lighter
      // border: 1px solid $primary
      // background-color: blue
</style>
