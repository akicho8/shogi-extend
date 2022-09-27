<template lang="pug">
.ShareBoardMemberList.SideColumn.column(:class="has_content_class(base.visible_member_infos)")
  .SideColumnScroll(ref="SideColumnScroll")
    .mini_title.is-clickable.player_names_copy_handle(@click="base.player_names_copy_handle")
      | メンバー
    .ShareBoardAvatarLinesWrap
      template(v-if="base.order_enable_p")
        template(v-if="base.order_unit.state_name === 'O1State'")
          // 従来の分けない方法
          .ShareBoardAvatarLines
            ShareBoardMemberListOne(v-for="info in base.visible_member_infos" :base="base" :info="info")
        template(v-if="base.order_unit.state_name === 'O2State'")
          template(v-if="true")
            // member_infos の中身を余さず表示する方法
            // ・名前が重複していても表示する
            .LocationBlock(v-for="location in Location.values")
              .LocationTitle
                b-tag(rounded) {{location.name}}
              .ShareBoardAvatarLines
                ShareBoardMemberListOne(v-for="info in base.visible_member_groups[location.key]" :base="base" :info="info")
            .LocationBlock(v-if="present_p(base.visible_member_groups['watcher'])")
              .LocationTitle
                b-tag(rounded) 観戦
              .ShareBoardAvatarLines
                ShareBoardMemberListOne(v-for="info in base.visible_member_groups['watcher']" :base="base" :info="info")
          template(v-if="false")
            // simple_teams を元に表示する方法
            // ・名前が重複している場合に1つしか表示されないのでやめ
            template(v-for="(user_names, i) in base.order_unit.simple_teams")
              .LocationBlock
                .LocationTitle.is-hidden
                  b-tag(rounded) {{Location.fetch(i).name}}
                .ShareBoardAvatarLines
                  template(v-for="user_name in user_names")
                    template(v-if="base.room_user_names_hash[user_name]")
                      ShareBoardMemberListOne(:base="base" :info="base.room_user_names_hash[user_name]")
      template(v-else)
        .ShareBoardAvatarLines
          ShareBoardMemberListOne(v-for="info in base.visible_member_infos" :base="base" :info="info")
</template>

<script>
import { support_child } from "../support_child.js"
import dayjs from "dayjs"
import { Location } from "shogi-player/components/models/location.js"

export default {
  name: "ShareBoardMemberList",
  mixins: [support_child],
  methods: {
  },
  computed: {
    Location() { return Location },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.ShareBoardMemberList.column
  +desktop
    +SideColumnScrollOn

  .ShareBoardAvatarLinesWrap
    display: flex
    flex-direction: column
    gap: 1rem // 先後間の隙間。△の上の隙間に相当する
</style>
