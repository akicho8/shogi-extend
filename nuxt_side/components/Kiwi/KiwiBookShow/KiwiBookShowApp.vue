<template lang="pug">
client-only
  .KiwiBookShowApp
    DebugBox(v-if="development_p")
      p OK

    p(v-if="$fetchState.error" v-text="$fetchState.error.message")
    b-loading(:active="$fetchState.pending")

    //- b-navbar(fixed-top type="is-success")

    KiwiBookShowNavbar(:base="base")
    KiwiBookShowSidebar(:base="base")

    MainSection(v-if="base.book")
      .container.is-fluid
        KiwiBookShowTop(:base="base" ref="KiwiBookShowTop")

    KiwiBookShowDebugPanels(:base="base" v-if="development_p")
</template>

<script>
import { Book           } from "../models/book.js"

import { support_parent } from "./support_parent.js"

import { app_mode              } from "./app_mode.js"
import { app_support           } from "./app_support.js"
import { app_sidebar           } from "./app_sidebar.js"
import { app_op                } from "./app_op.js"
import { app_table             } from "./app_table.js"
import { app_storage           } from "./app_storage.js"
import { app_book_message           } from "./app_book_message.js"
import { app_book_room      } from "./app_book_room.js"

import _ from "lodash"

export default {
  name: "KiwiBookShowApp",
  mixins: [
    support_parent,
    app_mode,
    app_support,
    app_sidebar,
    app_op,
    app_table,
    app_storage,
    app_book_message,
    app_book_room,
  ],

  data() {
    return {
      config: null,
      book: null,
    }
  },

  // fetchOnServer: false,
  async fetch() {
    // app/controllers/api/kiwi/books_controller.rb
    const params = {
      ...this.$route.params,
      ...this.$route.query,
    }
    const e = await this.$axios.$get("/api/kiwi/books/show.json", {params})

    this.config = e.config
    this.book = new Book(this, e.book)
    // this.saved_xitems = _.cloneDeep(this.book.xitems)

    this.clog("process.client", process.client)
    this.clog("process.server", process.server)

    if (process.client) {
      this.book_room_create()
      // this.play_start()
    }
    // this.mode_set("standby")

    // if (process.browser) {
    // if (true) {
    //   this.play_start()
    // } else {
    //   this.mode_set("standby")
    // }

    // this.st_init()
  },

  mounted() {
    // this.clog("book", this.book)
    // this.ga_click("インスタント将棋動画")
  },

  computed: {
    base()    { return this },
    meta()    { return this.book?.og_meta },

    owner_p() {
      if (this.book) {
        return this.g_current_user && this.g_current_user.id === this.book.user.id
      }
    },

  // owner_p(user) {
  //   // 新規レコードは誰でもオーナー
  //   if (this.new_record_p) {
  //     return true
  //   }
  //
  //   if (user) {
  //     return user.id === this.user.id
  //   }
  // }

  },
}
</script>

<style lang="sass">
@import "../all_support.sass"
.STAGE-development
  .KiwiBookShowApp
    .container
      border: 1px dashed change_color($danger, $alpha: 0.5)
    .columns
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .column
      border: 1px dashed change_color($success, $alpha: 0.5)

.KiwiBookShowApp
  .MainSection.section
    +mobile
      padding: 0.75rem
    +tablet
      padding: 1.5rem
</style>
