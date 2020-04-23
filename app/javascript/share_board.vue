<template lang="pug">
.share_board
  .columns
    .column
      b-dropdown.dropdown_menu(position="is-bottom-left")
        b-icon.has-text-grey-light.is_clickable(slot="trigger" icon="dots-vertical")
        b-dropdown-item(@click="piyo_shogi_open_handle") ぴよ将棋
        b-dropdown-item(@click="kento_open_handle") KENTO
        b-dropdown-item(@click="kifu_copy_handle") 棋譜コピー
        b-dropdown-item(separator)
        b-dropdown-item(@click="source_read_handle") 棋譜読み込み

      .title_container.has-text-centered
        .title.is-4.is-marginless(@click="title_edit")
          span.is_clickable {{current_title}}
        .turn_offset.has-text-weight-bold {{turn_offset}}手目

      .sp_container
        shogi_player(
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
          :flip="current_flip"
          @update:play_mode_advanced_full_moves_sfen="play_mode_advanced_full_moves_sfen_set"
          @update:turn_offset="turn_offset_set"
        )

      .tweet_button_container
        .buttons.is-centered
          b-button.has-text-weight-bold(@click="tweet_handle" icon-left="twitter" :type="advanced_p ? 'is-info' : ''" :disabled="bs_error")

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
        div initial_flip={{initial_flip}}
        div current_body={{current_body}}
        pre {{JSON.stringify(record, null, 4)}}
</template>

<script>
export default {
  name: "share_board",
  mixins: [
  ],
  props: {
    info: { required: false },
  },
  data() {
    return {
      record: null,       // js 側だけで足りると思っていたけどやっぱり必要だった。整合性チェックと kento_app_path のためにある
      bs_error: null,     // BioshogiError の情報 (Hash)
      current_body: null, // 渡している棋譜
      turn_offset: null,  // 現在の手数
      current_title: null,        // 現在のタイトル
      current_flip: null,

      // その他
      change_counter: 1, // 1:更新した状態からはじめる 0:更新してない状態(変更したいとボタンが反応しない状態)
    }
  },

  created() {
    this.record        = this.info.record
    this.current_body  = this.info.record.sfen_body
    this.turn_offset   = this.info.record.initial_turn
    this.current_title = this.$route.query.title || "指し継ぎリレー将棋"
    this.current_flip  = this.initial_flip
  },

  watch: {
    current_body()  { this.url_replace() },
    turn_offset()   { this.url_replace() },
    current_title() { this.url_replace() },
  },

  methods: {
    turn_offset_set(v) {
      this.turn_offset = v
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
      params.set("edit_mode", "share_board")

      this.http_command("POST", this.$route.path, params, e => {
        this.change_counter = 0

        this.bs_error = null

        if (e.bs_error) {
          this.bs_error = e.bs_error
          const message = `${e.bs_error.message}。手を戻して指し直してください`

          this.talk(message, {rate: 1.5})
          this.$buefy.dialog.alert({
            title: "ERROR",
            message: message,
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
      url.searchParams.set("title", this.current_title)
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
        inputAttrs: { type: "text", value: this.current_title, required: false },
        onConfirm: value => this.current_title = value || "指し継ぎリレー将棋",
      })
    },

    source_read_handle() {
      // this.$on("foo", e => alert(`on:${e}`))

      const body_input_modal = this.$buefy.modal.open({
        parent: this,
        hasModalCard: true,
        animation: "",
        component: {
          template: `
            <div class="modal-card is-size-7 share_board">
              <header class="modal-card-head">
                <p class="modal-card-title">棋譜</p>
              </header>
              <section class="modal-card-body">
                <b-input type="textarea" v-model="any_source" ref="any_source" />
              </section>
              <footer class="modal-card-foot">
                <b-button @click="submit_handle" type="is-primary">反映</b-button>
              </footer>
            </div>
          `,
          data() {
            return {
              any_source: "",
            }
          },
          mounted() {
            this.desktop_focus_to(this.$refs.any_source.$refs.textarea)
          },
          methods: {
            submit_handle() {
              this.$emit("update:any_source", this.any_source)
            },
          },
        },
        events: {
          "update:any_source": any_source => {
            this.http_get_command("/api/general/any_source_to_sfen", {any_source: any_source}, e => {
              if (e.bs_error) {
                this.general_warning_notice(e.bs_error.message)
              }
              if (e.sfen) {
                this.general_ok_notice("反映しました")
                this.current_body = e.sfen
                this.turn_offset = e.turn_max
                this.current_flip = false
                body_input_modal.close()
              }
            })
          },
        },
      })
    },
  },

  computed: {
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
        return this.piyo_shogi_full_url(this.basic_url, this.turn_offset, false)
      }
    },

    kento_app_with_params_url() {
      if (this.record) {
        return this.kento_full_url(this.record, this.turn_offset, false) // FIXME: kentoのURLはjs側で作る
      }
    },

    tweet_body() {
      return this.basic_url
    },

    // 反転した状態で開始するか？ (後手の手番のときに反転する)
    initial_flip() {
      return ((this.info.record.initial_turn + this.info.record.preset_info.handicap_shift) % 2) === 1
    },

    advanced_p() {
      return this.turn_offset > this.info.record.initial_turn
    },
  },
}
</script>

<style lang="sass">
@import "./stylesheets/bulma_init.scss"
.share_board
  ////////////////////////////////////////////////////////////////////////////////
  .title_container
    .title
    .turn_offset
      margin-top: 0.65rem

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
