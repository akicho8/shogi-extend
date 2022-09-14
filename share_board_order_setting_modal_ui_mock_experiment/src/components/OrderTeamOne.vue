<template lang="pug">
.OrderTeamOne
  .OrderTeamOneTitle.is-size-7.has-text-weight-bold
    | {{label}}
  VueDraggable(
    tag="ul"
    :animation="200"
    group="OrderTeam"
    ghostClass="ghost_element"
    v-model="base[team_key]"
    )
    template(v-for="row in base[team_key]")
      li.is-size-7(:key="row")
        | {{row}}
</template>

<script>
import VueDraggable from "vuedraggable"

export default {
  inject: ["base"],
  props: {
    team_key: { type: String, required: true, },
    label:    { type: String, required: true, },
  },
  components: {
    VueDraggable,
  },
}
</script>

<style lang="sass">
.OrderTeamOne
  overflow: hidden
  white-space: nowrap
  min-width: 3rem
  text-align: center
  border: 1px dashed change_color(blue, $alpha: 0.5)

  .OrderTeamOneTitle
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
