<template lang="pug">
.WkbkBookEditApp
  DebugBox
    template(v-if="book")
      p book.user.id: {{book.user && book.user.id}}
      p g_current_user.id: {{g_current_user && g_current_user.id}}
      p owner_p: {{owner_p}}
      p editable_p: {{editable_p}}
  b-loading(:active="$fetchState.pending")
  .MainContainer(v-if="!$fetchState.pending")
    WkbkBookEditNavbar(:base="base")
    MainSection.is_mobile_padding_zero
      .container
         WkbkBookEditForm(:base="base")
</template>

<script>
import MemoryRecord from 'js-memory-record'
import dayjs from "dayjs"

import { support_parent } from "./support_parent.js"

import { Book       } from "../models/book.js"
import { FolderInfo } from "../models/folder_info.js"

export default {
  name: "WkbkBookIndexApp",
  mixins: [
    support_parent,
  ],

  data() {
    return {
      book: null,
    }
  },

  fetch() {
    const params = {
      ...this.$route.params,
      ...this.$route.query,
    }
    return this.$axios.$get("/api/wkbk/books/edit.json", {params}).then(e => {
      if (!e.book) {
        this.$nuxt.error({statusCode: 403, message: "非公開のためアクセスできるのは作成者だけです"})
        return
      }
      this.config = e.config
      this.book = new Book(e.book)
    })
  },

  methods: {
    save_handle() {
      this.sound_play("click")

      if (this.sns_login_required()) {
        return
      }

      if (!this.editable_p) {
        this.toast_ng("所有者でないため更新できません")
        return
      }

      if (!this.book.title) {
        this.toast_warn("なんかしらのタイトルを捻り出して入力してください")
        return
      }

      // https://day.js.org/docs/en/durations/diffing
      const before_save_button_name = this.save_button_name
      return this.$axios.$post("/api/wkbk/books/save.json", {book: this.book}).then(e => {
        if (e.form_error_message) {
          this.toast_warn(e.form_error_message)
        }
        if (e.book) {
          this.book = new Book(e.book)

          this.toast_ok(`${before_save_button_name}しました`)

          this.$router.push({name: "library-books", query: {scope: this.book.folder_key}})
        }
      })
    },
  },

  computed: {
    base()                { return this                                         },
    save_button_name()    { return this.book.new_record_p ? "保存" : "更新" },
    FolderInfo()          { return FolderInfo },

    //////////////////////////////////////////////////////////////////////////////// 編集権限
    owner_p()    { return this.book.owner_p(this.g_current_user) },
    editable_p() { return this.owner_p                               },
    disabled_p() { return !this.editable_p                           },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.STAGE-development
  .WkbkBookEditApp
    .container
      border: 1px dashed change_color($danger, $alpha: 0.5)
    .columns.is-gapless
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .column
      border: 1px dashed change_color($success, $alpha: 0.5)

.WkbkBookEditApp
  .MainSection.section
    padding: 0

  .MainTabs
    .tab-content
      display: none
</style>
