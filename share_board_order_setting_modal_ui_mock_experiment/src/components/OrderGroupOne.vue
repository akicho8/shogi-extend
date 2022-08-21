<template lang="pug">
.OrderGroupOne
  .OrderGroupOneTitle.is-size-7.has-text-weight-bold
    | {{label}}
  VueDraggable(
    :class="position"
    tag="ul"
    :animation="200"
    group="OrderGroup"
    ghostClass="ghost_element"
    v-model="base[group_key]"
    )
    template(v-for="row in base[group_key]")
      li.is-size-7(:key="row.user_name")
        | {{row.user_name}}
</template>

<script>
import VueDraggable from "vuedraggable"

export default {
  inject: ["base"],
  props: {
    group_key: { type: String, required: true, },
    position:  { type: String, required: true, },
    label:     { type: String, required: true, },
  },
  components: {
    VueDraggable,
  },
}
</script>

<style lang="sass">
.OrderGroupOne
  overflow: hidden
  white-space: nowrap
  min-width: 3rem
  text-align: center
  border: 1px dashed change_color(blue, $alpha: 0.5)

  .OrderGroupOneTitle
    border: 1px dashed change_color(blue, $alpha: 0.5)
  ul
    border: 1px dashed change_color(red, $alpha: 0.5)
    height: 100% // ← 超重要。ulの下の空いた空間にdropできるようになる
    cursor: move
    .ghost_element
      opacity: 0.5
    li
      border: 1px dashed change_color(blue, $alpha: 0.5)
      background-color: change_color(blue, $alpha: 0.1)
      line-height: 1.5
      padding: 0.25rem
</style>
