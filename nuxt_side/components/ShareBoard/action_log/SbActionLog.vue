<template lang="pug">
.SbActionLog.SideColumn.column(:class="has_content_class(SB.action_logs)")
  .SideColumnScroll(ref="SideColumnScroll")
    .mini_title(v-if="SB.debug_mode_p")
      | 操作履歴
      span.mini_title_desc
        | タップで戻れる
    .SbAvatarLines
      template(v-for="(e, i) in SB.action_logs")
        SbAvatarLine.is-clickable(:info="e" tag="a" :key="e.unique_key" @click="SB.al_click_handle(e)" :xbadge_show_p="false")
          template(v-if="e.label")
            template(v-if="e.label && e.label_type")
              b-tag.flex_item(:type="e.label_type" size="is-small") {{e.label}}
            template(v-else)
              .flex_item.action_label1 {{e.label}}

          template(v-if="e.lmi")
            .flex_item {{e.lmi.next_turn_offset}}
            .flex_item {{e.lmi.kif_without_from}}

          template(v-for="e in e.illegal_names")
            b-tag.flex_item(type="is-danger" size="is-small") {{e}}

          .flex_item.is-size-7(v-if="'elapsed_sec' in e") {{-e.elapsed_sec}}秒
          .flex_item.is-size-7.time_format(v-if="e.performed_at && development_p") {{e.dispay_time}}
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "SbActionLog",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../sass/support.sass"
.SbActionLog.column
  +SideColumnScrollOn
  +touch
    height: 16rem
</style>
