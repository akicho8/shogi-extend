<template lang="pug">
.WkbkBookShowApp
  DebugBox
    template(v-if="book")
      p book.user.id: {{book.user && book.user.id}}
      p g_current_user.id: {{g_current_user && g_current_user.id}}
      p owner_p: {{owner_p}}
      p editable_p: {{editable_p}}
  b-loading(:active="$fetchState.pending")
  .MainContainer(v-if="!$fetchState.pending")
    WkbkBookShowNavbar(:base="base")
    MainSection.is_mobile_padding_zero
      .container
        keep-alive
          //- WkbkBookShowPlacement(:base="base"  v-if="current_tab_info.key === 'placement_mode'")
          //- WkbkBookShowAnswerCreate(:base="base" v-if="current_tab_info.key === 'answer_create_mode'" ref="WkbkBookShowAnswerCreate")
          //- WkbkBookShowForm(:base="base")
          WkbkBookShowValidation(:base="base")
</template>

<script>
import { support_parent } from "./support_parent.js"
import { Book    } from "../models/book.js"
import { FolderInfo  } from '../models/folder_info.js'

export default {
  name: "WkbkBookIndexApp",
  mixins: [
    support_parent,
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
      valid_count:    null, // 検証モードで正解した数
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

      // this.valid_count = 0

      this.talk(this.book.direction_message)
    })
  },

  methods: {
    // FIXME: イベントで受けとる
    current_moves() {
      return this.$refs.WkbkBookShowAnswerCreate.$refs.main_sp.sp_object().moves_take_turn_offset
    },

    play_mode_advanced_moves_set(moves) {
      // if (this.book.moves_answers.length === 0) {
      //   if (this.exam_run_count === 0) {
      //     this.toast_warn("正解を作ってからやってください")
      //   }
      // }
      if (this.book.moves_valid_p(moves)) {
        this.sound_play("o")
        this.toast_ok("正解")
        // this.valid_count += 1
      }
      // this.exam_run_count += 1
    },

  },

  computed: {
    base()                { return this                                         },

    //////////////////////////////////////////////////////////////////////////////// 編集権限
    owner_p()    { return this.book.owner_p(this.g_current_user) },
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
