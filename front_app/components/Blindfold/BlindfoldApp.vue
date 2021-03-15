<template lang="pug">
client-only
  .BlindfoldApp
    b-sidebar.is-unselectable.BlindfoldApp-Sidebar(fullheight right overlay v-model="sidebar_p")
      .mx-4.my-4
        .is-flex.is-justify-content-start.is-align-items-center
          b-button(@click="sidebar_toggle" icon-left="menu")
        .mt-4
          b-menu
            b-menu-list(label="Action")
              b-menu-item.is_active_unset(label="局面編集" @click="mode_toggle_handle")
              b-menu-item.is_active_unset(label="ツイート" @click="tweet_handle" v-if="scene === 'play_mode'")
        .box.mt-5
          .title.is-5 設定
          b-field(custom-class="is-small" label="再生速度")
            b-slider(v-bind="slider_attrs" v-model="talk_rate" :min="0.5" :max="1.5" :step="0.001")

    MainNavbar(:spaced="false")
      template(slot="brand")
        NavbarItemHome
        b-navbar-item.has-text-weight-bold(tag="nuxt-link" :to="{name: 'blindfold'}") {{current_title}}
      template(slot="end")
        //- b-navbar-item.has-text-weight-bold(@click="tweet_handle" v-if="scene === 'play_mode'")
        //-   b-icon(icon="twitter" type="is-white")

        b-navbar-item.has-text-weight-bold(@click="mode_toggle_handle" v-if="scene === 'edit_mode'")
          | 編集完了
        b-navbar-item.sidebar_toggle_navbar_item(@click="sidebar_toggle" v-if="scene === 'play_mode'")
          b-icon(icon="menu")

    MainSection.is_mobile_padding_zero
      .container
        .columns.is-centered
          .column(v-if="scene === 'play_mode'")
            .buttons.is-centered.are-medium
              template(v-if="talk_now")
                b-button(@click="stop_handle" icon-left="stop")
              template(v-else)
                b-button(@click="play_handle" icon-left="play")

          .MainColumn.column(v-if="scene === 'edit_mode'")
            CustomShogiPlayer.is_mobile_vertical_good_style(
              :sp_body="sp_body"
              :sp_sound_enabled="true"
              sp_run_mode="edit_mode"
              sp_summary="is_summary_off"
              sp_slider="is_slider_on"
              sp_controller="is_controller_on"
              sp_human_side="both"
              @update:edit_mode_snapshot_sfen="edit_mode_snapshot_sfen_set"
            )
    DebugPre {{$data}}
</template>

<script>
import _ from "lodash"

import { support_parent } from "./support_parent.js"
import { app_storage } from "./app_storage.js"

export default {
  name: "BlindfoldApp",
  mixins: [
    support_parent,
    app_storage,
  ],
  props: {
    config: { type: Object, required: true },
  },
  data() {
    return {
      yomiage_body: null,
      talk_now: false,
      sp_body: null,
      current_title: "目隠し詰将棋",
      scene: "play_mode",
      sidebar_p: false,
    }
  },
  created() {
  },
  mounted() {
    this.$watch(() => [
      this.sp_body,
    ], () => {
      this.$router.replace({query: this.current_url_params}).catch(e => {})
    })
    this.sp_body = this.$route.query.body || "position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l18p 1"
  },
  methods: {
    async play_handle() {
      this.sound_play('click')
      if (!this.yomiage_body) {
        await this.$axios.$post("/api/blindfold.json", {sfen: this.sp_body}).then(e => {
          if (e.bs_error) {
            this.bs_error_message_dialog(e.bs_error)
          }
          if (e.yomiage_body) {
            this.yomiage_body = e.yomiage_body
          }
        })
      }
      if (this.yomiage_body) {
        this.talk_stop()
        this.talk_now = true
        this.talk(this.yomiage_body, {rate: this.talk_rate, onend: () => this.talk_now = false})
      }
    },

    stop_handle() {
      this.talk_stop()
      this.talk_now = false
      this.sound_play('click')
    },

    sidebar_toggle() {
      this.sound_play('click')
      this.sidebar_p = !this.sidebar_p
    },

    edit_mode_snapshot_sfen_set(v) {
      if (this.scene === "edit_mode") { // 操作モードでも呼ばれるから
        this.sp_body = v
      }
    },

    tweet_handle() {
      this.sound_play("click")
      this.tweet_window_popup({text: this.tweet_body})
    },

    // 操作←→編集 切り替え
    mode_toggle_handle() {
      this.sidebar_p = false
      this.sound_play("click")
      this.yomiage_body = null
      if (this.scene === "play_mode") {
        this.scene = "edit_mode"
      } else {
        this.scene = "play_mode"
      }
    },
  },

  computed: {
    slider_attrs() {
      return {
        indicator: true,
        tooltip: false,
        size: "is-small",
      }
    },

    current_url_params() {
      return {
        body: this.sp_body,
      }
    },
    current_url() {
      let url = new URL(this.$config.MY_SITE_URL + `/blindfold`)
      _.each(this.current_url_params, (v, k) => {
        url.searchParams.set(k, v)
      })
      return url.toString()
    },
    tweet_body() {
      let o = ""
      o += "\n"
      o += "#" + this.current_title
      o += "\n"
      o += this.current_url
      return o
    },
  },
}
</script>

<style lang="sass">
@import "./support.sass"

.STAGE-development
  .BlindfoldApp
    .CustomShogiPlayer
    .ShogiPlayerGround
    .ShogiPlayerWidth
      border: 1px dashed change_color($success, $alpha: 0.5)

.BlindfoldApp-Sidebar
  .menu-label
    margin-top: 2em
  .b-slider
    .b-slider-thumb-wrapper.has-indicator
      .b-slider-thumb
        padding: 8px 4px
        font-size: 10px

.BlindfoldApp
  .navbar-end
    .sidebar_toggle_navbar_item
      padding-left: 1.5rem
      padding-right: 1.5rem

  .buttons
    .button
      min-width: 6rem
    +mobile
      margin: 4rem 0

  .MainSection.section
    +mobile
      padding: 0.75rem 0 0

  .MainColumn
    +tablet
      padding-top: unset
      padding-bottom: unset
      max-width: 70vmin

  // .CustomShogiPlayer
  //   +mobile
  //     --sp_piece_count_font_size: 8px
</style>
