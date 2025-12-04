<template lang="pug">
.SbMemberList.SideColumn.column(:class="has_content_class(SB.visible_member_infos)")
  .SideColumnScroll(ref="SideColumnScroll")
    .mini_title.is-clickable.player_names_copy_handle(@click="SB.player_names_copy_handle" v-if="SB.debug_mode_p")
      | メンバー
    .SbAvatarLinesWrap
      template(v-if="SB.order_enable_p")
        template(v-if="true")
          // member_infos の中身を余さず表示する方法
          // ・名前が重複していても表示する
          .TeamBlock(v-for="location in SB.Location.values" :class="location.key")
            .TeamName
              HexagonMark(:location_key="location.key")
            .SbAvatarLines
              SbMemberOne(v-for="info in SB.visible_member_groups[location.key]" :info="info" :key="info.from_connection_id")
          .TeamBlock.watcher(v-if="$GX.present_p(SB.visible_member_groups['watcher'])")
            .TeamName.is-invisible
              b-tag(rounded) 観戦
            .SbAvatarLines
              SbMemberOne(v-for="info in SB.visible_member_groups['watcher']" :info="info" :key="info.from_connection_id")
        template(v-if="false")
          // simple_teams を元に表示する方法
          // ・名前が重複している場合に1つしか表示されないのでやめ
          template(v-for="(user_names, i) in SB.order_flow.simple_teams")
            .TeamBlock
              .TeamName
                b-tag(rounded) {{SB.Location.fetch(i).name}}
              .SbAvatarLines
                template(v-for="user_name in user_names")
                  template(v-if="SB.room_user_names_hash[user_name]")
                    SbMemberOne(:info="SB.room_user_names_hash[user_name]")
      template(v-else)
        .SbAvatarLines
          SbMemberOne(v-for="info in SB.visible_member_infos" :info="info" :key="info.from_connection_id")
</template>

<script>
import dayjs from "dayjs"
import { support_child } from "../support_child.js"

export default {
  name: "SbMemberList",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../sass/support.sass"
.SbMemberList.column
  +desktop
    +SideColumnScrollOn

  .SbAvatarLinesWrap
    display: flex
    flex-direction: column
    gap: 1rem // 先後間の隙間。△の上の隙間に相当する
    .TeamBlock
      .TeamName
        margin-left: 7px
        font-size: 0.75rem
</style>
