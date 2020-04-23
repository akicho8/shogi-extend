<template lang="pug">
.relay_board
  .columns
    .column
      b-dropdown.dropdown_menu(position="is-bottom-left")
        b-icon.has-text-grey-light.is_clickable(slot="trigger" icon="dots-vertical")
        b-dropdown-item(@click="piyo_shogi_open_handle") ぴよ将棋
        b-dropdown-item(@click="kento_open_handle") KENTO
        b-dropdown-item(@click="kifu_copy_handle") 棋譜コピー

      .title_container.has-text-centered
        .title.is-4(@click="title_edit")
          span.is_clickable {{title}}
        .subtitle.turn_offset.is-5 {{turn_offset}}手目

      .sp_container
        shogi_player(
          ref="main_sp"
          :run_mode="'play_mode'"
          :start_turn="turn_offset"
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
          @update:turn_offset="turn_offset_set"
        )

      .tweet_button_container
        .buttons.is-centered
          b-button.has-text-weight-bold(@click="tweet_handle" icon-left="twitter" type="is-info" rounded :disabled="bs_error") ツイート

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
      .box
        .buttons
          b-button(tag="a" :href="json_url") json
          b-button(tag="a" :href="png_url") png
        .content
          p
            b Twitter Card 画像
          p
            img(:src="png_url" width="256")
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
      record: null, // js 側だけで足りると思っていたけどやっぱり必要だった。整合性チェックと kento_app_path のためにある
      bs_error: null,    // BioshogiError の情報 (Hash)
      current_body: null,       // 渡している棋譜
      turn_offset: null,
      title: null,

      // その他
      change_counter: 1, // 1:更新した状態からはじめる 0:更新してない状態(変更したいとボタンが反応しない状態)
    }
  },

  created() {
    this.record       = this.info.record
    this.current_body = this.info.record.sfen_body
    this.turn_offset  = this.info.record.force_turn
    this.title        = this.$route.query.title || "リレー将棋"

    this.url_replace()
  },

  methods: {
    turn_offset_set(v) {
      this.turn_offset = v
      this.url_replace()
    },

    play_mode_advanced_full_moves_sfen_set(v) {
      this.change_counter += 1
      this.record = null
      this.bs_error = null

      this.current_body = v
      this.url_replace()
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
      this.record_fetch(() => {})
    },

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
      const params = new URLSearchParams()
      params.set("body", this.current_body)
      params.set("edit_mode", "relay_board")

      this.http_command("POST", this.$route.path, params, e => {
        this.change_counter = 0

        this.bs_error = null

        if (e.bs_error) {
          this.bs_error = e.bs_error
          this.talk(this.bs_error.message, {rate: 1.5})

          this.$buefy.dialog.alert({
            title: "ERROR",
            message: e.bs_error.message,
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

    url_replace() {
      window.history.replaceState("", null, this.basic_url)
    },

    url_build(format = null) {
      const url = new URL(location)
      url.searchParams.set("body", this.current_body)
      url.searchParams.set("turn", this.turn_offset)
      url.searchParams.set("title", this.title)
      if (format) {
        url.searchParams.set("format", format)
      }
      return url.toString()
    },

    title_edit() {
      this.$buefy.dialog.prompt({
        message: "タイトル",
        confirmText: "更新",
        cancelText: "キャンセル",
        inputAttrs: { type: "text", value: this.title, required: false },
        onConfirm: value => this.title = value || "リレー将棋",
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

    basic_url() {
      return this.url_build()
    },

    json_url() {
      return this.url_build("json")
    },

    png_url() {
      return this.url_build("png")
    },

    piyo_shogi_app_with_params_url() {
      if (this.record) {
        return this.piyo_shogi_full_url(this.record, this.turn_offset, false)
      }
    },

    kento_app_with_params_url() {
      if (this.record) {
        return this.kento_full_url(this.record, this.turn_offset, false)
      }
    },

    tweet_body() {
      if (this.record) {
        return this.basic_url
      }
    },
  },
}
</script>

<style lang="sass">
@import "./stylesheets/bulma_init.scss"
.relay_board
  ////////////////////////////////////////////////////////////////////////////////
  .title_container
    .title
      .turn_offset
        margin-left: 0.1rem

  ////////////////////////////////////////////////////////////////////////////////
  position: relative
  .dropdown_menu
    position: absolute
    top: 0rem
    right: 0rem
    z-index: 1

  ////////////////////////////////////////////////////////////////////////////////
  .sp_container
    margin-top: 0.8rem

  ////////////////////////////////////////////////////////////////////////////////
  .tweet_button_container
    margin-top: 1.5rem
</style>
