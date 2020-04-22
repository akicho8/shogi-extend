<template lang="pug">
.relay_board
  .columns
    .column
      b-dropdown.relay_menu(position="is-bottom-left")
        b-icon.has-text-grey-light(slot="trigger" icon="dots-vertical")
        b-dropdown-item(@click="piyo_shogi_open_handle") ぴよ将棋
        b-dropdown-item(@click="kento_open_handle") KENTO
        b-dropdown-item(@click="kifu_copy_handle") 棋譜コピー

      .sp_container
        shogi_player(
          ref="main_sp"
          :run_mode="'play_mode'"
          :kifu_body="current_body"
          :summary_show="false"
          :slider_show="true"
          :setting_button_show="development_p"
          :size="'large'"
          :sound_effect="true"
          :controller_show="true"
          :human_side_key="'both'"
          :theme="'real'"
          :vlayout="false"
          @update:play_mode_advanced_full_moves_sfen="play_mode_advanced_full_moves_sfen_set"
        )

      .tweet_button_container
        .buttons.is-centered
          b-button(@click="tweet_handle" icon-left="twitter" type="is-info" rounded :disabled="bs_error") ツイート

      //- template(v-if="!bs_error")
      //-   .other_buttons_container
      //-     hr
      //-     .buttons.are-small.is-centered
      //-       b-button(@click="validate_handle" :icon-left="record ? 'check' : 'doctor'" :disabled="record" v-if="development_p") 検証
      //-
      //-       piyo_shogi_button(type="button" @click.prevent="piyo_shogi_open_handle" tag="a" :href="piyo_shogi_app_with_params_url")
      //-
      //-       // remote fetch が終わる前に href="" に対して遷移しようとするため .prevent が必要
      //-       // なぜ href で URL を入れるのか？ → 長押しで別タブで飛びたいため
      //-       kento_button(@click.prevent="kento_open_handle" tag="a" :href="kento_app_with_params_url")
      //-
      //-       kif_copy_button(@click="kifu_copy_handle")

  .columns(v-if="development_p")
    .column
      div {{current_body}}
      pre {{JSON.stringify(record, null, 4)}}
</template>

<script>
export default {
  name: "relay_board",
  mixins: [
  ],
  props: {
    info: { required: false },
  },
  data() {
    return {
      // データ
      record: null,
      bs_error: null,    // BioshogiError の情報 (Hash)
      dirty_p: null,
      current_body: null,

      // その他
      change_counter: 1, // 1:更新した状態からはじめる 0:更新してない状態(変更したいとボタンが反応しない状態)
    }
  },
  created() {
    this.record = this.info.record
    this.current_body = this.record.sfen_body

    window.history.replaceState("", null, this.permalink_url)
  },
  methods: {
    play_mode_advanced_full_moves_sfen_set(v) {
      this.change_counter += 1
      this.record = null
      this.bs_error = null
      this.dirty_p = true

      this.current_body = v
      window.history.replaceState("", null, this.permalink_url)

      // this.validate_handle()
    },
    piyo_shogi_open_handle() {
      this.record_fetch(() => this.self_window_open(this.piyo_shogi_app_with_params_url))
    },

    kento_open_handle() {
      this.record_fetch(() => this.other_window_open(this.kento_app_with_params_url))
    },

    kifu_copy_handle() {
      this.record_fetch(() => this.simple_clipboard_copy(this.record.kif_format_body))
    },

    tweet_handle() {
      this.record_fetch(() => this.self_window_open(this.tweet_intent_url(this.tweet_body)))
    },

    validate_handle() {
      this.record_fetch(() => { })
    },

    // helper

    // private

    record_fetch(callback) {
      if (this.change_counter === 0) {
        if (this.record) {
          callback()
        }
      }
      if (this.change_counter >= 1) {
        this.record_create(callback)
      }
    },

    record_create(callback) {
      // this.$gtag.event("create", {event_category: "なんでも棋譜変換"})

      const params = new URLSearchParams()
      params.set("body", this.current_body)
      params.set("edit_mode", "relay2")

      this.http_command("POST", this.$route.path, params, e => {
        this.change_counter = 0

        this.bs_error = null

        if (e.bs_error) {
          this.bs_error = e.bs_error
          this.talk(this.bs_error.message, {rate: 1.5})

          this.$buefy.dialog.alert({
            title: "ERROR",
            message: `<div>${e.bs_error.message}</div><div class="error_message_pre_with_margin is-size-7">${e.bs_error.board}</div>`,
            canCancel: ["outside", "escape"],
            type: "is-danger",
            hasIcon: true,
            icon: "times-circle",
            iconPack: "fa",
            trapFocus: true,
          })
        }

        if (e.record) {
          this.record = e.record
          callback()
        }
      })
    },
  },
  computed: {
    field_message() {
      if (this.change_counter === 0) {
        if (this.bs_error) {
          return _.compact([this.bs_error.message, this.bs_error.message_prefix]).join(" ")
        }
      }
    },
    permalink_url() {
      const url = new URL(location)
      url.searchParams.set("body", this.current_body)
      return url.toString()
    },
    piyo_shogi_app_with_params_url() {
      if (this.record) {
        return this.piyo_shogi_full_url(this.record, this.record.turn_max, false)
      }
    },

    kento_app_with_params_url() {
      if (this.record) {
        return this.kento_full_url(this.record, this.record.turn_max, false)
      }
    },

    tweet_body() {
      if (this.record) {
        return this.as_full_url(this.record.show_path)
      }
    },
  },
}
</script>

<style lang="sass">
@import "./stylesheets/bulma_init.scss"
.relay_board
  position: relative
  .relay_menu
    position: absolute
    top: 0rem
    right: 0rem
    z-index: 1
  .tweet_button_container
    margin-top: 1.5rem
  .sp_container
    margin-top: 0rem
  // .other_buttons_container
  //   margin-top: 1.75rem
</style>
