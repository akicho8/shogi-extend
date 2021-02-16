<template lang="pug">
client-only
  .WkbkBookShowApp
    DebugBox
      p re_total_sec: {{re_total_sec}}
      p mode: {{mode}}
      template(v-if="interval_counter")
        p interval_counter.count: {{interval_counter.count}}
      template(v-if="book && false")
        p jo_counts: {{jo_counts}}
        p book.user.id: {{book.user && book.user.id}}
        p g_current_user.id: {{g_current_user && g_current_user.id}}
        p goal_p: {{goal_p}}
        p rest_count: {{rest_count}}
        p current_index: {{current_index}}
        p max_count: {{max_count}}

    p(v-if="$fetchState.error" v-text="$fetchState.error.message")
    b-loading(:active="$fetchState.pending")

    //- b-navbar(fixed-top type="is-success")

    WkbkBookShowNavbar(:base="base")
    WkbkBookShowSidebar(:base="base")

    .MainContainer(v-if="!$fetchState.pending && !$fetchState.error")
      template(v-if="is_standby_p")
        WkbkBookShowTop(:base="base" ref="WkbkBookShowTop")
      template(v-if="is_running_p")
        template(v-if="base.current_article.folder_key === 'private'")
          WkbkBookShowAccessBlock(:base="base")
        template(v-else)
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

import { app_xitems   } from "./app_xitems.js"
import { app_mode       } from "./app_mode.js"
import { app_support    } from "./app_support.js"
import { app_tweet_recent      } from "./app_tweet_recent.js"
import { app_tweet_stat   } from "./app_tweet_stat.js"
import { app_sidebar    } from "./app_sidebar.js"
import { app_op  } from "./app_op.js"
import { app_table  } from "./app_table.js"

import _ from "lodash"

export default {
  name: "WkbkBookShowApp",
  mixins: [
    support_parent,
    app_xitems,
    app_mode,
    app_support,
    app_tweet_recent,
    app_tweet_stat,
    app_sidebar,
    app_op,
    app_table,
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
    // this.saved_xitems = _.cloneDeep(this.book.xitems)

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

    this.st_init()
  },

  mounted() {
    // this.clog("book", this.book)
    // this.ga_click("インスタント将棋問題集")
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
  // .MainSection.section
  //   padding: 0

  .MainTabs
    .tab-content
      display: none
</style>
