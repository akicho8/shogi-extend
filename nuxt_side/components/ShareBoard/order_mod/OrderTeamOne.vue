<template lang="pug">
.OrderTeamOne
  //- ghostClass="ghost_element"
  //- @start="event_check"
  .OrderTeamOneTitle.is-size-7.has-text-weight-bold.is-clickable(@click="TheOSM.state_toggle_handle")
    | {{label}}
  VueDraggable(
    tag="ul"
    :animation="200"
    group="OrderTeam"
    v-model="current_user_list"
    @end="end_handle"
    )
    template(v-for="e in current_user_list")
      li(:key="e.user_name")
        | {{e.user_name}}
</template>

<script>
import VueDraggable from "vuedraggable"

export default {
  props: {
    user_list:    { type: Array,   required: true,  },
    label:        { type: String,  required: true,  },
  },
  components: {
    VueDraggable,
  },
  inject: ["TheOSM"],
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
  methods: {
    end_handle() {
      this.TheOSM.base.os_change.append("順番")
    },
  },
}
</script>

<style lang="sass">
.OrderTeamOne
  overflow: hidden
  white-space: nowrap
  min-width: 4rem
  max-width: 6rem
  text-align: center
  border: 1px border $grey-light
  font-size: $size-7

  .OrderTeamOneTitle
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
