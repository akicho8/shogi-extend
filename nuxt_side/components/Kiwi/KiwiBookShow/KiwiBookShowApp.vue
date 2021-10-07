<template lang="pug">
client-only
  .KiwiBookShowApp
    DebugBox(v-if="development_p")
      p $fetchState.pending: {{$fetchState.pending}}
      p ac_book_room_connected_count: {{ac_book_room_connected_count}}

    FetchStateErrorMessage(:fetchState="$fetchState")
    b-loading(:active="$fetchState.pending")

    KiwiBookShowNavbar(:base="base")
    KiwiBookShowSidebar(:base="base")

    MainSection.when_mobile_footer_scroll_problem_workaround
      .container.is-fluid
        KiwiBookShowMain(:base="base" ref="KiwiBookShowMain" v-if="base.book")

    KiwiBookShowDebugPanels(:base="base" v-if="development_p")
</template>

<script>
import { Book             } from "../models/book.js"

import { support_parent   } from "./support_parent.js"
import { app_board         } from "./app_board.js"
import { app_support      } from "./app_support.js"
import { app_sidebar      } from "./app_sidebar.js"
import { app_op           } from "./app_op.js"
import { app_table        } from "./app_table.js"
import { app_storage      } from "./app_storage.js"
import { app_book_message } from "./app_book_message.js"
import { app_book_room    } from "./app_book_room.js"

import _ from "lodash"

export default {
  name: "KiwiBookShowApp",
  mixins: [
    support_parent,
    app_board,
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

    this.clog("process.client", process.client)
    this.clog("process.server", process.server)

    if (process.client) {
      this.book_room_create()
      this.ga_click(`動画 ID:${this.book.id} ${this.book.title}`)
    }
  },

  computed: {
    base()    { return this },
    meta()    { return this.book?.og_meta },

    owner_p() {
      if (this.g_current_user && this.book) {
        return this.g_current_user.id === this.book.user.id
      }
    },
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
