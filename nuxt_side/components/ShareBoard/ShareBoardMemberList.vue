<template lang="pug">
.ShareBoardMemberList.SideColumn.column(:class="has_content_class(base.visible_member_infos)")
  .SideColumnScroll(ref="SideColumnScroll")
    .mini_title.is-clickable.player_names_copy_handle(@click="base.player_names_copy_handle")
      | メンバー
    .ShareBoardAvatarLines
      template(v-for="info in base.visible_member_infos")
        ShareBoardMemberListOne(:base="base" :info="info")
</template>

<script>
import { support_child } from "./support_child.js"
import dayjs from "dayjs"
import { Location } from "shogi-player/components/models/location.js"

export default {
  name: "ShareBoardMemberList",
  mixins: [support_child],
  methods: {
  },
}
</script>

<style lang="sass">
@import "./support.sass"
.ShareBoardMemberList.column
  +desktop
    +SideColumnScrollOn
</style>
