<template lang="pug">
.OrderTeamOne
  .OrderTeamOneTitle.is-size-7.has-text-weight-bold.is-clickable.has-text-centered(@click="$emit('label_click', $event)")
    | {{label}}
  VueDraggable.draggable_area(
    tag="div"
    :animation="200"
    group="OrderTeam"
    v-model="current_items"
    @choose="() => sfx_click()"
    @start="start_handle"
    @end="end_handle"
    draggable=".draggable_item"
    )
    template(v-for="e in current_items")
      .draggable_item(:key="e.unique_key" :class="name_class(e)" :style="name_style(e)")
        .icon_with_name
          XemojiWrap.is-flex-shrink-0(:str="name_emoji(e)" v-if="name_emoji(e)")
          span.name
            | {{e.to_s}}
</template>

<script>
import VueDraggable from "vuedraggable"
import { MemberStatusInfo } from "./member_status_info.js"
import { support_child } from "../support_child.js"
import { GX } from "@/components/models/gx.js"

export default {
  name: "OrderTeamOne",
  mixins: [support_child],
  inject: ["TheOSM"],           // OrderSettingModal
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
      this.SB.new_o.os_dnd_count += 1
    },
    end_handle() {
      this.sfx_play("se_transition_up")
      this.SB.new_o.os_dnd_count -= 1
      this.SB.new_o.order_flow.cache_clear()
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
      const value = GX.irand()
      return { "animation-delay": `${value}s` }
    },

    member_status_key_by(item) {
      // return "status_leave"
      // return "status_disconnet"
      // return "status_look_away"

      const member_info = this.SB.room_user_names_hash[item.to_s]
      if (member_info == null) {
        return "status_leave"
      }
      if (this.SB.member_is_look_away(member_info)) {
        return "status_look_away"
      }
      if (this.SB.member_is_heartbeat_lost(member_info)) {
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
  display: flex          // ラベルとドラッグエリアをまとめて flex にすることで複数のドラッグエリアの縦幅100%が親をはみ出さなくなる
  flex-direction: column // 縦並び

  width: 8rem            // サイズを固定する(重要) 指定しないとハンドルネームの長さによって崩れる

  white-space: nowrap
  font-size: $size-7

  .draggable_area
    display: flex
    gap: 6px        // 上下の差
    flex-direction: column

    margin-top: 6px // ラベルとの隙間
    height: 100%    // ← ulの下の空いた空間にdropできるようになる (超重要)

    // &:hover
    //   border: 1px solid $grey-lighter

    // ドラッグ要素
    .draggable_item
      background-color: $white
      border: 1px solid $grey-lighter
      border-radius: 2px
      padding: 0.25rem 0.75rem
      cursor: move

      display: flex
      justify-content: center

      // overflow: hidden で切ったとき右のパッディングがなくなるため .draggable_item に直接テキストを入れてはいけない
      .icon_with_name
        display: flex
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

.STAGE-development
  .OrderTeamOne
    border: 1px dashed change_color($primary, $alpha: 0.5)
    .OrderTeamOneTitle
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .draggable_area
      border: 2px solid change_color($danger, $alpha: 0.5)
</style>
