<template lang="pug">
client-only
  .KiwiLemonNewApp

    DebugBox(v-if="development_p")
      p column_size_code: {{column_size_code}}
      p xresource: {{xresource}}
      //- p $fetchState: {{$fetchState}}

    //- FetchStateErrorMessage(:fetchState="$fetchState")
    //- b-loading(:active="$fetchState.pending")

    KiwiLemonNewSidebar(:base="base")
    MainNavbar
      template(slot="brand")
        NavbarItemHome
        b-navbar-item.has-text-weight-bold(@click="reset_handle") 動画作成
      template(slot="end")
        b-navbar-item.px_5_if_tablet(tag="nuxt-link" :to="{name: 'video-studio'}" @click.native="sfx_play_click()")
          b-icon(icon="table-cog")
        NavbarItemLogin
        NavbarItemProfileLink
        NavbarItemSidebarOpen(@click="base.sidebar_toggle")

    MainSection.when_mobile_footer_scroll_problem_workaround
      .container
        .columns.is-multiline.is-centered.is-variable.is-0-mobile.is-4-tablet.is-5-desktop.is-6-widescreen.is-7-fullhd
          KiwiLemonNewForm(:base="base" ref="KiwiLemonNewForm")
          KiwiLemonNewProgress(:base="base")
          KiwiLemonNewReview(:base="base")
          KiwiLemonNewValidation(:base="base")
          KiwiLemonNewQueueSelf(:base="base")
          KiwiLemonNewQueueAll(:base="base")
          KiwiLemonNewAdmin(:base="base")

    KiwiLemonNewDebugPanels(:base="base" v-if="development_p")
</template>

<script>
import { support_parent       } from "./support_parent.js"
import { mod_chore            } from "./mod_chore.js"
import { mod_review           } from "./mod_review.js"
import { mod_sidebar          } from "./mod_sidebar.js"
import { mod_storage          } from "./mod_storage.js"
import { mod_lemon_room     } from "./mod_lemon_room.js"
import { mod_queue_all        } from "./mod_queue_all.js"
import { mod_queue_self       } from "./mod_queue_self.js"
import { mod_admin       } from "./mod_admin.js"
import { mod_form             } from "./mod_form.js"
import { mod_zombie_kill      } from "./mod_zombie_kill.js"
import { mod_probe_show       } from "./mod_probe_show.js"
import { mod_my_skelton       } from "./mod_my_skelton.js"
import { mod_color_select     } from "./mod_color_select.js"
import { mod_audio_select     } from "./mod_audio_select.js"
import { mod_compute_from_bpm } from "./mod_compute_from_bpm.js"
import { mod_source_trim      } from "./mod_source_trim.js"
import { mod_help             } from "./mod_help.js"

import { Lemon } from "../models/lemon.js"

import _ from "lodash"

export default {
  name: "KiwiLemonNewApp",
  mixins: [
    support_parent,
    mod_chore,
    mod_review,
    mod_sidebar,
    mod_storage,
    mod_lemon_room,
    mod_queue_all,
    mod_queue_self,
    mod_admin,
    mod_form,
    mod_zombie_kill,
    mod_probe_show,
    mod_my_skelton,
    mod_color_select,
    mod_audio_select,
    mod_compute_from_bpm,
    mod_source_trim,
    mod_help,
  ],

  data() {
    return {
      list_tab_index: 0,   // 変換リスト切り替えタブ (本来不要なはずだけど v-model を指定しないとマウント時に中身が反映されない)
      response_hash: null, // FreeBattle のインスタンスの属性たち + いろいろんな情報
    }
  },

  props: {
    xresource: { type: Object, required: true, },
  },

  mounted() {
    this.app_log("動画作成")
    if (this.nuxt_login_required()) { return }
    this.debug_alert("mounted")
  },

  // fetchOnServer: false,
  // fetch() {
  //   this.debug_alert("fetch begin")
  //   const params = {
  //   }
  //   return this.$axios.$get("/api/kiwi/lemons/xresource_fetch.json", {params: params}).then(e => {
  //     this.xresource = e
  //     this.debug_alert("fetch end")
  //   })
  // },

  computed: {
    base() { return this },
    Lemon() { return Lemon },
    meta() {
      return {
        title: "動画作成",
        description: "棋譜を動画にしたいときにどうぞ。mp4, gif, png, zip に変換できます",
        og_image_key: "video-new",
      }
    },
  },
}

</script>

<style lang="sass">
.KiwiLemonNewApp
  .MainSection.section
    +mobile
      // ios Safari では底辺部分をタップするとスクロールしてしまい使いにくいためスペースをあける
      padding-bottom: 12rem
    +tablet
      padding: 2rem

  .list_tabs
    .tab-content
      padding: 0.75rem 0

  // .MainColumn
  //   // +tablet
  //   //   max-width: 40rem

  // for KiwiLemonNewQueueAll, KiwiLemonNewQueueSelf
  .table_status_column
    width: 5rem // "成功" が "変換中" になったときガクッとさせないための幅

.STAGE-development
  .KiwiLemonNewApp
    .columns
      border: 1px dashed change_color($danger, $alpha: 0.5)
    .column
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
