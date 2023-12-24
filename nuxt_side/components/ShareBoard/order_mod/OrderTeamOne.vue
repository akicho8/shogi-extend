<template lang="pug">
.OrderTeamOne
  .OrderTeamOneTitle.is-size-7.has-text-weight-bold.is-clickable(@dblclick="TheOSM.state_toggle_handle")
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
      li(:key="e.unique_key" :class="name_class(e)" :style="name_style(e)")
        .text
          XemojiWrap(:str="name_emoji(e)" v-if="name_emoji(e)")
          span.name
            | {{e.to_s}}
</template>

<script>
import VueDraggable from "vuedraggable"
import { MemberStatusInfo } from "./member_status_info.js"
import { support_child } from "../support_child.js"

export default {
  name: "OrderTeamOne",
  inject: ["TheOSM"],
  props: {
    label: { type: String, required: true, },
    items: { type: Array,  required: true, },
  },
  components: {
    VueDraggable,
  },
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
    // dnd

    start_handle() {
      this.SB.new_v.os_dnd_count += 1
    },
    end_handle() {
      this.SB.new_v.os_dnd_count -= 1
      this.SB.new_v.order_unit.cache_clear()
    },

    // name

    // 名前。ここに印を入れる案もある
    name_emoji(item) {
      return this.MemberStatusInfo.fetch(this.member_status_key_by(item)).emoji
    },
    name_class(item) {
      return this.MemberStatusInfo.fetch(this.member_status_key_by(item)).css_class
    },
    // すべてのの名前のぷるぷる効果が同期していると変なのでずらす
    name_style(item) {
      const value = this.$gs.irand()
      return { "animation-delay": `${value}s` }
    },

    member_status_key_by(item) {
      // return "status_leave"
      // return "status_disconnet"
      // return "status_blur"

      const member_info = this.SB.room_user_names_hash[item.to_s]
      if (member_info == null) {
        return "status_leave"
      }
      if (this.SB.member_is_window_blur(member_info)) {
        return "status_blur"
      }
      if (this.SB.member_is_disconnect(member_info)) {
        return "status_disconnet"
      }
      return "status_active"
    },
  },
  computed: {
    MemberStatusInfo() { return MemberStatusInfo }
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

      // overflow: hidden で切ったとき右のパッディングがなくなるため li に直接テキストを入れない
      .text
        display: flex
        align-items: center
        justify-content: center
        gap: 0.25rem            // ドクロと名前の隙間

        line-height: 2.5
        overflow: hidden

      // 絵文字で差があるため背景まで変更するとややこしくなる
      &.status_good
        // color: $grey
        // background-color: $primary-light
      &.status_bad
        // color: $grey
        // background-color: $white-bis

      // ドラッグできることを感づかせるための施策
      box-shadow: 0px 0px 4px hsl(0, 0%, 90%) // 動かせると感じてもらいたいため少し浮いているように見せる
      animation: shake_up 0.05s ease-in-out 0s infinite alternate
      @keyframes shake_up
        0%
          transform: rotateZ(-2deg)
        100%
          transform: rotateZ(2deg)

    // 持ち上げられた元の要素
    .sortable-ghost
      opacity: 0

    // 持ち上げて動かしている要素
    .sortable-drag
      opacity: 1.0 ! important  // 1.0 にしたいが Sortable 側で 0.8 がハードコーディングされていて変更できない(FIXME)
</style>
