<template lang="pug">
.SbMemberList.SideColumn.column(:class="has_content_class(TheSb.visible_member_infos)")
  .SideColumnScroll(ref="SideColumnScroll")
    .mini_title.is-clickable.player_names_copy_handle(@click="TheSb.player_names_copy_handle")
      | メンバー
    .ShareBoardAvatarLinesWrap
      template(v-if="TheSb.order_enable_p")
        template(v-if="TheSb.order_unit.state_name === 'O1State'")
          // 従来の分けない方法
          .ShareBoardAvatarLines
            SbMemberOne(v-for="info in TheSb.visible_member_infos" :info="info")
        template(v-if="TheSb.order_unit.state_name === 'O2State'")
          template(v-if="true")
            // member_infos の中身を余さず表示する方法
            // ・名前が重複していても表示する
            .TeamBlock(v-for="location in Location.values" :class="location.key")
              .TeamName
                HexagonMark(:location_key="location.key")
              .ShareBoardAvatarLines
                SbMemberOne(v-for="info in TheSb.visible_member_groups[location.key]" :info="info")
            .TeamBlock.watcher(v-if="present_p(TheSb.visible_member_groups['watcher'])")
              .TeamName.is-invisible
                b-tag(rounded) 観戦
              .ShareBoardAvatarLines
                SbMemberOne(v-for="info in TheSb.visible_member_groups['watcher']" :info="info")
          template(v-if="false")
            // simple_teams を元に表示する方法
            // ・名前が重複している場合に1つしか表示されないのでやめ
            template(v-for="(user_names, i) in TheSb.order_unit.simple_teams")
              .TeamBlock
                .TeamName
                  b-tag(rounded) {{Location.fetch(i).name}}
                .ShareBoardAvatarLines
                  template(v-for="user_name in user_names")
                    template(v-if="TheSb.room_user_names_hash[user_name]")
                      SbMemberOne(:info="TheSb.room_user_names_hash[user_name]")
      template(v-else)
        .ShareBoardAvatarLines
          SbMemberOne(v-for="info in TheSb.visible_member_infos" :info="info")
</template>

<script>
import { support_child } from "../support_child.js"
import dayjs from "dayjs"
import { Location } from "shogi-player/components/models/location.js"

export default {
  name: "SbMemberList",
  mixins: [support_child],
  inject: ["TheSb"],
  computed: {
    Location() { return Location },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.SbMemberList.column
  +desktop
    +SideColumnScrollOn

  .ShareBoardAvatarLinesWrap
    display: flex
    flex-direction: column
    gap: 1rem // 先後間の隙間。△の上の隙間に相当する
    .TeamBlock
      .TeamName
        margin-left: 7px
        font-size: 0.75rem
</style>
