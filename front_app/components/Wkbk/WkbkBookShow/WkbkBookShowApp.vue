<template lang="pug">
.WkbkBookShowApp
  DebugBox
    p mode: {{mode}}
    template(v-if="book")
      p book.user.id: {{book.user && book.user.id}}
      p g_current_user.id: {{g_current_user && g_current_user.id}}
      p goal_p: {{goal_p}}
      p rest_count: {{rest_count}}
      p current_index: {{current_index}}
      p max_count: {{max_count}}
      template(v-if="current_exist_p")
        p current_sp_body: {{current_sp_body}}
        p current_sp_viewpoint: {{current_sp_viewpoint}}
  b-loading(:active="$fetchState.pending")
  .MainContainer(v-if="!$fetchState.pending")
    WkbkBookShowNavbar(:base="base")
    MainSection.is_mobile_padding_zero
      .container
        template(v-if="is_standby_p")
          WkbkBookShowStandby(:base="base")
        template(v-if="is_running_p")
          WkbkBookShowSp(:base="base")
          WkbkBookShowAnswer(:base="base")
        template(v-if="is_goal_p")
          WkbkBookShowGoal(:base="base")
  DebugPre
    | {{$data}}
</template>

<script>
import { support_parent } from "./support_parent.js"
import { Book    } from "../models/book.js"
import { FolderInfo  } from '../models/folder_info.js'
import { app_articles } from "./app_articles.js"
import { app_mode } from "./app_mode.js"
import { app_support } from "./app_support.js"

export default {
  name: "WkbkBookIndexApp",
  mixins: [
    support_parent,
    app_articles,
    app_mode,
    app_support,
  ],

  data() {
    return {
      //////////////////////////////////////////////////////////////////////////////// 静的情報
      LineageInfo: null,        // 問題の種類
      FolderInfo: null,         // 問題の入れ場所

      //////////////////////////////////////////////////////////////////////////////// 新規・編集
      tab_index:        null,
      book:         null,
      //////////////////////////////////////////////////////////////////////////////// 検証モード
    }
  },

  fetch() {
    // app/controllers/api/wkbk_controller/book_mod.rb
    // http://localhost:3000/api/wkbk.json?remote_action=book_show_fetch&book_id=2
    return this.$axios.$get("/api/wkbk.json", {params: {remote_action: "book_show_fetch", ...this.$route.params, ...this.$route.query}}).then(e => {

      // this.LineageInfo = LineageInfo.memory_record_reset(e.LineageInfo)
      this.FolderInfo  = FolderInfo.memory_record_reset(e.FolderInfo)
      this.config = e.config

      this.book = new Book(e.book)

      if (true) {
        this.setup_first()
      } else {
        this.mode_set("standby")
      }
    })
  },

  methods: {
  },

  computed: {
    base() { return this },
    owner_p() { return this.book.owner_p(this.g_current_user) },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.STAGE-development
  .WkbkBookShowApp
    .container
      border: 1px dashed change_color($danger, $alpha: 0.5)
    .columns.is-gapless
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .column
      border: 1px dashed change_color($success, $alpha: 0.5)

.WkbkBookShowApp
  .MainSection.section
    padding: 0

  .MainTabs
    .tab-content
      display: none
</style>
