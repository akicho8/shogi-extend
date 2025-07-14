<template lang="pug">
client-only
  .WkbkBookShowApp(:style="component_style" :class="component_class")
    DebugBox(v-if="development_p")
      p appearance_theme_key: {{appearance_theme_key}}
      p re_total_sec: {{re_total_sec}}
      p mode: {{mode}}
      template(v-if="interval_counter")
        p interval_counter.counter: {{interval_counter.counter}}
      template(v-if="book")
        p jo_counts: {{jo_counts}}
        p book.user.id: {{book.user && book.user.id}}
        p g_current_user.id: {{g_current_user && g_current_user.id}}
        p goal_p: {{goal_p}}
        p rest_count: {{rest_count}}
        p current_index: {{current_index}}
        p max_count: {{max_count}}

    FetchStateErrorMessage(:fetchState="$fetchState")
    b-loading(:active="$fetchState.pending")

    //- b-navbar(fixed-top type="is-success")

    WkbkBookShowNavbar(:base="base")
    WkbkBookShowSidebar(:base="base")

    .MainContainer(v-if="!$fetchState.pending && !$fetchState.error")
      template(v-if="is_standby_p")
        WkbkBookShowTop(:base="base" ref="WkbkBookShowTop")
      template(v-if="is_running_p")
        template(v-if="base.current_article.invisible_p")
          WkbkBookShowAccessBlock(:base="base")
        template(v-else)
          WkbkBookShowSp(:base="base" ref="WkbkBookShowSp")
      template(v-if="is_goal_p")
        WkbkBookShowGoal(:base="base")

    DebugPre(v-if="!$fetchState.pending && !$fetchState.error && development_p")
      | {{base.current_exist_p && base.current_article}}
      |
      | {{$data}}
</template>

<script>
import { Book           } from "../models/book.js"

import { support_parent } from "./support_parent.js"

import { mod_xitems            } from "./mod_xitems.js"
import { mod_article           } from "./mod_article.js"
import { mod_kifu_copy_buttons } from "./mod_kifu_copy_buttons.js"
import { mod_mode              } from "./mod_mode.js"
import { mod_support           } from "./mod_support.js"
import { mod_tweet_recent      } from "./mod_tweet_recent.js"
import { mod_tweet_stat        } from "./mod_tweet_stat.js"
import { mod_sidebar           } from "./mod_sidebar.js"
import { mod_op                } from "./mod_op.js"
import { mod_table             } from "./mod_table.js"
import { mod_shortcut          } from "./mod_shortcut.js"
import { mod_storage           } from "./mod_storage.js"
import { mod_kb_shortcut_modal } from "./mod_kb_shortcut_modal.js"
import { mod_interval_counter  } from "./mod_interval_counter.js"
import { mod_time_limit        } from "./mod_time_limit.js"
import { mod_appearance_theme  } from "./appearance_theme/mod_appearance_theme.js"
import { mod_sound_effect      } from "./mod_sound_effect.js"

import _ from "lodash"

export default {
  name: "WkbkBookShowApp",
  mixins: [
    support_parent,
    mod_xitems,
    mod_article,
    mod_kifu_copy_buttons,
    mod_mode,
    mod_support,
    mod_tweet_recent,
    mod_tweet_stat,
    mod_sidebar,
    mod_op,
    mod_table,
    mod_shortcut,
    mod_storage,
    mod_kb_shortcut_modal,
    mod_interval_counter,
    mod_time_limit,
    mod_appearance_theme,
    mod_sound_effect,
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
    const e = await this.$axios.$get("/api/wkbk/books/show.json", {params})

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
    // this.app_log("将棋ドリル")

    // if (this.nuxt_login_required()) { return }
  },

  provide() {
    return {
      TheApp: this,
    }
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

    // いちばん外側に設定するタグのstyleでグローバル的なものを指定する
    component_style() {
      if (this.pc_standby_ok >= 1) {
        return {
          // "--sb_board_width": this.sb_board_width,
          ...this.appearance_theme_info.to_style,
        }
      }
    },

    // いちばん外側に設定するタグのclassでグローバル的なものを指定する
    component_class() {
      if (this.pc_standby_ok >= 1) {
        return {
          [`is_mode_${this.mode}`]: true,
          [this.appearance_theme_info.key]: true,
        }
        // hv.debug_mode_p        = this.debug_mode_p
        // hv.order_enable_p      = this.order_enable_p
        // hv.current_turn_self_p = this.current_turn_self_p
        // hv.edit_mode_p         = this.edit_mode_p
        // hv.normal_mode_p       = !this.edit_mode_p
      }
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
@import "./appearance_theme/appearance_theme.sass"
@import "./layout.sass"

.STAGE-development
  .WkbkBookShowApp
    .container
      border: 1px dashed change_color($danger, $alpha: 0.5)
    .columns
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .column
      border: 1px dashed change_color($success, $alpha: 0.5)

.WkbkBookShowApp
  .MainTabs
    .tab-content
      display: none
</style>
