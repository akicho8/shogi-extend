<template lang="pug">
client-only
  .WkbkBookShowApp
    DebugBox
      p spent_sec: {{spent_sec}}
      p mode: {{mode}}
      template(v-if="interval_counter")
        p interval_counter.count: {{interval_counter.count}}
      template(v-if="book && false")
        p journal_ox_counts: {{journal_ox_counts}}
        p book.user.id: {{book.user && book.user.id}}
        p g_current_user.id: {{g_current_user && g_current_user.id}}
        p goal_p: {{goal_p}}
        p rest_count: {{rest_count}}
        p current_index: {{current_index}}
        p max_count: {{max_count}}
        template(v-if="current_exist_p")
          p current_sp_body: {{current_sp_body}}
          p current_sp_viewpoint: {{current_sp_viewpoint}}

    p(v-if="$fetchState.error" v-text="$fetchState.error.message")
    b-loading(:active="$fetchState.pending")

    //- b-navbar(fixed-top type="is-success")

    WkbkBookShowNavbar(:base="base")
    WkbkBookShowSidebar(:base="base")
    .MainContainer(v-if="!$fetchState.pending && !$fetchState.error")
      MainSection.is_mobile_padding_zero
        .container
          template(v-if="is_standby_p")
            WkbkBookShowStandby(:base="base")
          template(v-if="is_running_p")
            WkbkBookShowSp(:base="base")
            //- WkbkBookShowAnswer(:base="base")
          template(v-if="is_goal_p")
            WkbkBookShowGoal(:base="base")

    DebugPre
      | {{$data}}
</template>

<script>
import { Book           } from "../models/book.js"

import { support_parent } from "./support_parent.js"

import { app_articles   } from "./app_articles.js"
import { app_mode       } from "./app_mode.js"
import { app_support    } from "./app_support.js"
import { app_tweet      } from "./app_tweet.js"
import { app_journal   } from "./app_journal.js"
import { app_sidebar    } from "./app_sidebar.js"
import { app_op  } from "./app_op.js"

import _ from "lodash"

export default {
  name: "WkbkBookShowApp",
  mixins: [
    support_parent,
    app_articles,
    app_mode,
    app_support,
    app_tweet,
    app_journal,
    app_sidebar,
    app_op,
  ],

  data() {
    return {
      config: null,
      book: null,
    }
  },

  // fetchOnServer: false,
  async fetch() {
    // app/controllers/api/wkbk/books_controller.rb
    const params = {
      ...this.$route.params,
      ...this.$route.query,
    }
    const e = await this.$axios.$get("/api/wkbk/books/show.json", {params}).catch(e => {
      this.$nuxt.error(e.response.data)
      return
    })

    this.config = e.config
    this.book = new Book(e.book)
    this.current_index = 0
    this.saved_articles = _.cloneDeep(this.book.articles)

    this.clog("process.client", process.client)
    this.clog("process.server", process.server)

    if (process.client) {
      // this.play_start()
    }
    this.mode_set("standby")

    // if (process.browser) {
    // if (true) {
    //   this.play_start()
    // } else {
    //   this.mode_set("standby")
    // }

    if (process.client) {
      if (this.development_p) {
        this.journal_test()
      }
    }
  },

  mounted() {
    this.clog("book", this.book)
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
