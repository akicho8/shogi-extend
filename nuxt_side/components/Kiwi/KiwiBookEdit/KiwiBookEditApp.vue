<template lang="pug">
client-only
  .KiwiBookEditApp
    DebugBox(v-if="development_p")
      template(v-if="book")
        p book.user.id: {{book.user && book.user.id}}
        p g_current_user.id: {{g_current_user && g_current_user.id}}
        p owner_p: {{owner_p}}
        p editable_p: {{editable_p}}

    p(v-if="$fetchState.error" v-text="$fetchState.error.message")
    b-loading(:active="$fetchState.pending")

    KiwiBookEditNavbar(:base="base")

    MainSection.when_mobile_footer_scroll_problem_workaround
      .container.is-fluid
        KiwiBookEditForm(:base="base" v-if="!$fetchState.pending && !$fetchState.error")

    KiwiBookEditDebugPanels(:base="base" v-if="development_p")
</template>

<script>
import dayjs from "dayjs"

import { support_parent  } from "./support_parent.js"
import { app_book_delete } from "./app_book_delete.js"
import { app_storage     } from "./app_storage.js"

import { Book       } from "../models/book.js"

export default {
  name: "KiwiBookEditApp",
  mixins: [
    support_parent,
    app_book_delete,
    app_storage,
  ],

  data() {
    return {
      config: null,
      book: null,
      // meta: null,
    }
  },

  async fetch() {
    if (this.sns_login_required()) {
      return
    }

    const params = {
      ...this.$route.params,
      ...this.$route.query,
    }
    // app/controllers/api/kiwi/books_controller.rb
    const e = await this.$axios.$get("/api/kiwi/books/edit.json", {params})
    // if (e.error) {
    //   this.$nuxt.error(e.error)
    //   return
    // }
    this.config = e.config
    this.book = new Book(this, e.book)
    // this.meta = e.meta

    // 前回保存したときの値を初期値にする
    if (this.book.new_record_p) {
      // if (!this.book.sequence_key) {
      //   this.book.sequence_key = this.default_sequence_key
      // }
      if (!this.book.folder_key) {
        this.book.folder_key = this.default_folder_key
      }
    }
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

      if (this.blank_p(this.book.title)) {
        this.toast_warn("なんかしらのタイトルを捻り出してください")
        return
      }

      // https://day.js.org/docs/en/durations/diffing
      const new_record_p = this.book.new_record_p
      const before_save_button_name = this.save_button_name
      const loading = this.$buefy.loading.open()
      return this.$axios.$post("/api/kiwi/books/save.json", {book: this.book.post_params}).then(e => {
        if (e.form_error_message) {
          this.toast_warn(e.form_error_message)
        }
        if (e.book) {
          this.book = new Book(this, e.book)

          this.sound_stop_all()
          this.toast_ok(`${before_save_button_name}しました`)

          // 新規の初期値にするため保存しておく
          if (new_record_p) {
            // this.default_sequence_key = this.book.sequence_key
            this.default_folder_key = this.book.folder_key
          }

          // this.$router.push({name: "video-studio", query: {scope: this.book.folder_key}})
          this.$router.push({name: "video-studio"})
        }
      }).finally(() => {
        loading.close()
      })
    },
  },

  computed: {
    base()                { return this                                     },
    save_button_name()    { return this.book.new_record_p ? "登録" : "更新" },
    // SequenceInfo()        { return SequenceInfo },

    //////////////////////////////////////////////////////////////////////////////// 編集権限
    editable_p() { return this.owner_p                               },
    disabled_p() { return !this.editable_p                           },

    owner_p() {
      if (this.book && this.g_current_user) {
        return this.g_current_user.id === this.book.user.id
      }
    },
  },
}
</script>

<style lang="sass">
@import "../all_support.sass"
.KiwiBookEditApp
  .MainSection.section
    +mobile
      padding: 0.5rem
    +tablet
      padding: 1.0rem

.STAGE-development
  .KiwiBookEditApp
    .container
      border: 1px dashed change_color($danger, $alpha: 0.5)
    .columns
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .column
      border: 1px dashed change_color($success, $alpha: 0.5)
    .footer
      border: 1px dashed change_color($success, $alpha: 0.5)
</style>
