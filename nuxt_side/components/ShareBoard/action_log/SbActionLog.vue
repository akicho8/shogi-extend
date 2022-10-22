<template lang="pug">
.SbActionLog.SideColumn.column(:class="has_content_class(filtered_action_logs)")
  .SideColumnScroll(ref="SideColumnScroll")
    .mini_title(v-if="base.debug_mode_p")
      | 操作履歴
      span.mini_title_desc
        | タップで戻れる
    .SbAvatarLines
      template(v-for="(e, i) in filtered_action_logs")
        SbAvatarLine.is-clickable(:info="e" tag="a" :key="action_log_key(e)" @click="base.action_log_click_handle(e)" :medal_show_p="false")
          .flex_item(v-if="present_p(e.x_retry_count) && e.x_retry_count >= 1") 再送{{e.x_retry_count}}

          template(v-if="e.label")
            template(v-if="e.label && e.label_type")
              b-tag.flex_item(:type="e.label_type" size="is-small") {{e.label}}
            template(v-else)
              .flex_item {{e.label}}

          template(v-if="e.lmi")
            .flex_item {{e.lmi.next_turn_offset}}
            .flex_item {{e.lmi.kif_without_from}}
            template(v-for="e in e.lmi.foul_names")
              b-tag.flex_item(type="is-danger" size="is-small") {{e}}

          .flex_item.is-size-7(v-if="'elapsed_sec' in e") {{-e.elapsed_sec}}秒
          .flex_item.is-size-7.time_format(v-if="e.performed_at && development_p") {{time_format(e)}}
</template>

<script>
import { support_child } from "../support_child.js"
import dayjs from "dayjs"
import { Location } from "shogi-player/components/models/location.js"

export default {
  name: "SbActionLog",
  mixins: [support_child],
  mounted() {
    // if (this.development_p) {
    //   for (let i = 0; i < 10; i++) {
    //     this.base.al_add_test()
    //   }
    // }
  },
  methods: {
    action_log_key(e) {
      return [e.performed_at, e.turn, e.from_connection_id || ""].join("-")
    },
    time_format(v) {
      return dayjs(v.performed_at).format("HH:mm:ss")
    },
  },
  computed: {
    filtered_action_logs() {
      // return _.reverse(this.base.action_logs.slice())
      return this.base.action_logs
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.SbActionLog.column
  +SideColumnScrollOn
  +touch
    height: 16rem
</style>
