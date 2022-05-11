<template lang="pug">
.ShareBoardMemberList.SideColumn.column(:class="has_content_class(member_infos)")
  .SideColumnScroll(ref="SideColumnScroll")
    .mini_title
      | メンバー
    .ShareBoardAvatarLines
      template(v-for="info in member_infos")
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
  computed: {
    member_infos() {
      if (this.base.order_enable_p) {
        if (this.base.ordered_members) {
          return _.sortBy(this.base.member_infos, e => {
            let found = null
            if (false) {
              found = this.base.ordered_members.find(v => v.user_name === e.from_user_name) // O(n)
            } else {
              found = this.base.user_names_hash[e.from_user_name] // O(1)
            }
            if (found) {
              return found.order_index
            } else {
              // 見つからなかった人は「観戦」なので一番下に移動させておく
              return this.base.member_infos.length
            }
          })
        }
      }
      return this.base.member_infos
    },
  },
}
</script>

<style lang="sass">
@import "./support.sass"
.ShareBoardMemberList.column
  +tablet
    +SideColumnScrollOn
</style>
