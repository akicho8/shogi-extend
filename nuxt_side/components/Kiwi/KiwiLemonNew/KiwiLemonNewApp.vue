<template lang="pug">
client-only
  .KiwiLemonNewApp

    DebugBox(v-if="development_p")
      p column_size_code: {{column_size_code}}

    KiwiLemonNewSidebar(:base="base")
    MainNavbar
      template(slot="brand")
        NavbarItemHome
        b-navbar-item.has-text-weight-bold(@click="reset_handle") 動画作成
      template(slot="end")
        b-navbar-item.px_5_if_tablet(tag="nuxt-link" :to="{name: 'video-studio'}" @click.native="sound_play_click()")
          b-icon(icon="table-cog")
        NavbarItemLogin
        NavbarItemProfileLink
        b-navbar-item.px_5_if_tablet.sidebar_toggle_navbar_item(@click="base.sidebar_toggle")
          b-icon(icon="menu")

    MainSection.when_mobile_footer_scroll_problem_workaround
      .container
        .columns.is-multiline.is-centered.is-variable.is-0-mobile.is-4-tablet.is-5-desktop.is-6-widescreen.is-7-fullhd
          //- b-upload(@input="xaudio_file_upload_handle" @click.native="debug_alert('2回呼ばれる不具合があるため効果音off')")
          //-   .field
          //-     img(:src="url" width="128px")
          //-     template(v-if="xaudio_file")
          //-       .box
          //-         div {{xaudio_file.name}}
          //-         div {{xaudio_file.size}}
          //-         div {{xaudio_file.type}}

          //- .column
          //-   .box
          //-     KiwiLemonNewAudioPlay(:src="this.AudioThemeInfo.fetch('is_audio_theme_breakbeat_only').sample_source")
          //-     KiwiLemonNewAudioPlay(:src="this.AudioThemeInfo.fetch('is_audio_theme_breakbeat_only').sample_source" size="is-small")

          KiwiLemonNewForm(:base="base" ref="KiwiLemonNewForm" v-if="form_show_p")
          KiwiLemonNewProgress(:base="base")
          KiwiLemonNewReview(:base="base")
          KiwiLemonNewValidation(:base="base")
          .column.is-half
            b-tabs.list_tabs(:expanded="false" type="is-boxed" v-model="list_tab_index" @input="sound_play_click()")
              b-tab-item(label="あなた")
                KiwiLemonNewQueueSelf(:base="base")
              b-tab-item(label="みんな")
                KiwiLemonNewQueueAll(:base="base")

    KiwiLemonNewDebugPanels(:base="base" v-if="development_p")
</template>

<script>
import { support_parent       } from "./support_parent.js"
import { app_chore            } from "./app_chore.js"
import { app_review           } from "./app_review.js"
import { app_sidebar          } from "./app_sidebar.js"
import { app_storage          } from "./app_storage.js"
import { app_lemon_room     } from "./app_lemon_room.js"
import { app_queue_all        } from "./app_queue_all.js"
import { app_queue_self       } from "./app_queue_self.js"
import { app_form             } from "./app_form.js"
import { app_zombie_kill      } from "./app_zombie_kill.js"
import { app_probe_show       } from "./app_probe_show.js"
import { app_my_skelton       } from "./app_my_skelton.js"
import { app_color_select     } from "./app_color_select.js"
import { app_audio_select     } from "./app_audio_select.js"
import { app_compute_from_bpm } from "./app_compute_from_bpm.js"
import { app_source_trim      } from "./app_source_trim.js"
import { app_help             } from "./app_help.js"

import { Lemon } from "../models/lemon.js"

import _ from "lodash"

export default {
  name: "KiwiLemonNewApp",
  mixins: [
    support_parent,
    app_chore,
    app_review,
    app_sidebar,
    app_storage,
    app_lemon_room,
    app_queue_all,
    app_queue_self,
    app_form,
    app_zombie_kill,
    app_probe_show,
    app_my_skelton,
    app_color_select,
    app_audio_select,
    app_compute_from_bpm,
    app_source_trim,
    app_help,
  ],

  data() {
    return {
      list_tab_index: 0,   // 変換リスト切り替えタブ (本来不要なはずだけど v-model を指定しないとマウント時に中身が反映されない)
      response_hash: null, // FreeBattle のインスタンスの属性たち + いろいろんな情報
    }
  },
  mounted() {
    this.ga_click("動画作成")
    if (this.nuxt_login_required()) { return }
  },

  fetchOnServer: false,
  fetch() {
    this.debug_alert("fetch[begin]")
    const params = {
    }
    return this.$axios.$get("/api/kiwi/lemons/latest_info_reload.json", {params: params}).then(e => {
      this.debug_alert("fetch[end]")
    })
  },

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
