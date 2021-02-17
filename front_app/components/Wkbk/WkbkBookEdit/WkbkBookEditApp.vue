<template lang="pug">
client-only
  .WkbkBookEditApp
    DebugBox
      template(v-if="book")
        p book.user.id: {{book.user && book.user.id}}
        p g_current_user.id: {{g_current_user && g_current_user.id}}
        p owner_p: {{owner_p}}
        p editable_p: {{editable_p}}

    p(v-if="$fetchState.error" v-text="$fetchState.error.message")
    b-loading(:active="$fetchState.pending")

    WkbkBookEditNavbar(:base="base")

    .MainContainer(v-if="!$fetchState.pending && !$fetchState.error")
      MainSection.section
        .container
           WkbkBookEditForm(:base="base")

    DebugPre {{$data}}
</template>

<script>
import MemoryRecord from 'js-memory-record'
import dayjs from "dayjs"

import { support_parent } from "./support_parent.js"
import { app_table } from "./app_table.js"
import { app_upload } from "./app_upload.js"
import { app_book_delete } from "./app_book_delete.js"

import { Book       } from "../models/book.js"
import { SequenceInfo } from "../models/sequence_info.js"

export default {
  name: "WkbkBookEditApp",
  mixins: [
    support_parent,
    app_table,
    app_upload,
    app_book_delete,
  ],

  data() {
    return {
      config: null,
      book: null,
      meta: null,
    }
  },

  // fetch() {
  //   const params = {
  //     ...this.$route.params,
  //     ...this.$route.query,
  //   }
  //   // app/controllers/api/wkbk/books_controller.rb
  //   return this.$axios.$get("/api/wkbk/books/edit.json", {params}).then(e => {
  //     if (e.error) {
  //       this.$nuxt.error(e.error)
  //       return
  //     }
  //     this.config = e.config
  //     this.book = new Book(e.book)
  //     this.meta = e.meta
  //   })
  // },

  async fetch() {
    const params = {
      ...this.$route.params,
      ...this.$route.query,
    }
    // app/controllers/api/wkbk/books_controller.rb
    const e = await this.$axios.$get("/api/wkbk/books/edit.json", {params}).catch(e => {
      this.$nuxt.error(e.response.data)
      return
    })
    // if (e.error) {
    //   this.$nuxt.error(e.error)
    //   return
    // }
    this.config = e.config
    this.book = new Book(e.book)
    this.meta = e.meta
  },

  methods: {
    book_save_handle() {
      this.sound_play("click")

      if (this.sns_login_required()) {
        return
      }

      if (!this.editable_p) {
        this.toast_ng("所有者でないため更新できません")
        return
      }

      if (!this.book.title) {
        this.toast_warn("なんかしらのタイトルを捻り出してください")
        return
      }

      // https://day.js.org/docs/en/durations/diffing
      const before_save_button_name = this.save_button_name
      return this.$axios.$post("/api/wkbk/books/save.json", {book: this.book}).catch(e => {
        this.$nuxt.error(e.response.data)
        return
      }).then(e => {
        if (e.form_error_message) {
          this.toast_warn(e.form_error_message)
        }
        if (e.book) {
          this.book = new Book(e.book)

          this.toast_ok(`${before_save_button_name}しました`)

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
    .columns.is-gapless
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
