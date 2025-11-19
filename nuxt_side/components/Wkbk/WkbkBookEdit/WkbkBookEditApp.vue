<template lang="pug">
client-only
  .WkbkBookEditApp
    DebugBox(v-if="development_p")
      template(v-if="book")
        p book.user.id: {{book.user && book.user.id}}
        p g_current_user.id: {{g_current_user && g_current_user.id}}
        p owner_p: {{owner_p}}
        p editable_p: {{editable_p}}

    FetchStateErrorMessage(:fetchState="$fetchState")
    b-loading(:active="$fetchState.pending")

    WkbkBookEditNavbar(:base="base")

    .MainContainer(v-if="!$fetchState.pending && !$fetchState.error")
      MainSection
        .container
           WkbkBookEditForm(:base="base")

    DebugPre(v-if="development_p") {{$data}}
</template>

<script>
import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import dayjs from "dayjs"

import { support_parent } from "./support_parent.js"
import { mod_table } from "./mod_table.js"
import { mod_upload } from "./mod_upload.js"
import { mod_book_delete } from "./mod_book_delete.js"
import { mod_storage } from "./mod_storage.js"

import { Book       } from "../models/book.js"
import { SequenceInfo } from "../models/sequence_info.js"

export default {
  name: "WkbkBookEditApp",
  mixins: [
    support_parent,
    mod_table,
    mod_upload,
    mod_book_delete,
    mod_storage,
  ],

  data() {
    return {
      config: null,
      book: null,
      meta: null,
    }
  },

  mounted() {
    if (this.nuxt_login_required()) { return }
  },

  async fetch() {
    const params = {
      ...this.$route.params,
      ...this.$route.query,
    }
    // app/controllers/api/wkbk/books_controller.rb
    const e = await this.$axios.$get("/api/wkbk/books/edit.json", {params})
    // if (e.error) {
    //   this.$nuxt.error(e.error)
    //   return
    // }
    this.config = e.config
    this.book = new Book(e.book)
    this.meta = e.meta

    // 前回保存したときの値を初期値にする
    if (this.book.new_record_p) {
      if (!this.book.sequence_key) {
        this.book.sequence_key = this.default_sequence_key
      }
      if (!this.book.folder_key) {
        this.book.folder_key = this.default_folder_key
      }
    }

  },

  methods: {
    book_save_handle() {
      this.sfx_click()

      if (!this.editable_p) {
        this.toast_ng("所有者でないため更新できません")
        return
      }

      if (!this.book.title) {
        this.toast_warn("なんかしらのタイトルを捻り出そう")
        return
      }

      // https://day.js.org/docs/en/durations/diffing
      const new_record_p = this.book.new_record_p
      const before_save_button_name = this.save_button_name
      return this.$axios.$post("/api/wkbk/books/save.json", {book: this.book}).then(e => {
        if (e.form_error_message) {
          this.toast_warn(e.form_error_message)
        }
        if (e.book) {
          this.book = new Book(e.book)

          this.sfx_stop_all()
          this.toast_ok(`${before_save_button_name}しました`)

          // 新規の初期値にするため保存しておく
          if (new_record_p) {
            this.default_sequence_key = this.book.sequence_key
            this.default_folder_key = this.book.folder_key
          }

          // this.$router.push({name: "rack-books", query: {scope: this.book.folder_key}})
          this.$router.push({name: "rack-books"})
        }
      })
    },
  },

  computed: {
    base()                { return this                                         },
    save_button_name()    { return this.book.new_record_p ? "保存" : "更新" },
    SequenceInfo()        { return SequenceInfo },

    //////////////////////////////////////////////////////////////////////////////// 編集権限
    editable_p() { return this.owner_p                               },
    disabled_p() { return !this.editable_p                           },

    owner_p() {
      if (this.book) {
        return this.g_current_user && this.g_current_user.id === this.book.user.id
      }
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.STAGE-development
  .WkbkBookEditApp
    .container
      border: 1px dashed change_color($danger, $alpha: 0.5)
    .columns
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .column
      border: 1px dashed change_color($success, $alpha: 0.5)

.WkbkBookEditApp
  .MainSection.section
    +mobile
      padding: 0.5rem
    +tablet
      padding: 1.5rem

  .MainTabs
    .tab-content
      display: none
</style>
