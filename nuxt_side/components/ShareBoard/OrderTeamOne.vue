<template lang="pug">
.OrderTeamOne
  .OrderTeamOneTitle.is-size-7.has-text-weight-bold
    | {{label}}
  VueDraggable(
    tag="ul"
    :animation="200"
    group="OrderTeam"
    ghostClass="ghost_element"
    v-model="current_user_list"
    )
    template(v-for="e in current_user_list")
      li.is-size-7(:key="e")
        | {{e}}
</template>

<script>
import VueDraggable from "vuedraggable"

export default {
  inject: ["base"],
  props: {
    user_list: { type: Array,  required: true, },
    label:    { type: String, required: true, },
  },
  components: {
    VueDraggable,
  },
  data() {
    return {
      current_user_list: this.user_list,
    }
  },
  watch: {
    user_list() {
      this.current_user_list = this.user_list
    },
    current_user_list() {
      this.$emit("update:user_list", this.current_user_list)
    },
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
