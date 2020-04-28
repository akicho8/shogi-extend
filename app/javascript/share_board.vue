<template lang="pug">
.share_board
  .columns
    .column
      b-dropdown.dropdown_menu(position="is-bottom-left" v-if="run_mode === 'play_mode'")
        b-icon.has-text-grey-light.is_clickable(slot="trigger" icon="dots-vertical")
        template(v-if="run_mode === 'play_mode'")
          b-dropdown-item(:href="piyo_shogi_app_with_params_url") ぴよ将棋
          b-dropdown-item(:href="kento_app_with_params_url") KENTO

          b-dropdown-item(@click="kifu_copy_handle") 棋譜コピー
          b-dropdown-item(separator)
        b-dropdown-item(@click="mode_toggle_handle")
          template(v-if="run_mode === 'play_mode'")
            | 局面編集
          template(v-else)
            | 局面編集(終了)
        b-dropdown-item(@click="source_read_handle") 棋譜読み込み
        b-dropdown-item(@click="title_edit") タイトル編集

      .title_container.has-text-centered(v-if="run_mode === 'play_mode'")
        .title.is-4.is-marginless
          span.is_clickable(@click="title_edit") {{current_title}}
        .turn_offset.has-text-weight-bold {{turn_offset}}手目

      .sp_container
        shogi_player(
          :run_mode="run_mode"
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
          :flip.sync="current_flip"
          @update:play_mode_advanced_full_moves_sfen="play_mode_advanced_full_moves_sfen_set"
          @update:edit_mode_snapshot_sfen="edit_mode_snapshot_sfen_set"
          @update:turn_offset="turn_offset_set"
        )

      .tweet_button_container
        .buttons.is-centered
          b-button.has-text-weight-bold(@click="tweet_handle" icon-left="twitter" :type="advanced_p ? 'is-info' : ''" v-if="run_mode === 'play_mode'")
          a.delete.is-large(@click="mode_toggle_handle" v-if="run_mode === 'edit_mode'")

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
      // watch して url に反映するもの
      current_body:  this.info.record.sfen_body,                         // 渡している棋譜
      current_title: this.defval(this.$route.query.title, "リレー将棋"), // 現在のタイトル
      turn_offset:   this.info.record.initial_turn,                      // 現在の手数

      // urlには反映しない
      current_flip: this.info.record.flip,       // 反転用

      record: this.info.record, // バリデーション目的だったが自由になったので棋譜コピー用だけのためにある
      run_mode: "play_mode",    // 操作モードと局面編集モードの切り替え用
      edit_mode_body: null,     // 局面編集モードの局面
    }
  },

  created() {
    // どれかが変更されたらURLを更新
    this.$watch(() => [
      this.edit_mode_body,      // 編集モード中でもURLを変更したいため
      this.current_body,
      this.turn_offset,
      this.current_title,
    ], () => this.url_replace())
  },

  watch: {
    current_title() { this.sound_play("click") },
  },

  methods: {
    // 現在の手数を受けとる(URLに反映する)
    turn_offset_set(v) {
      this.turn_offset = v
    },

    // 再生モードで指したときmovesあり棋譜(URLに反映する)
    play_mode_advanced_full_moves_sfen_set(v) {
      this.record = null

      this.current_body = v
      this.url_replace()
    },

    // 編集モード時の局面
    // ・常に更新するが、URLにはすぐには反映しない→やっぱり反映する
    // ・あとで current_body に設定する
    // ・すぐに反映しないのは駒箱が消えてしまうため
    edit_mode_snapshot_sfen_set(v) {
      this.edit_mode_body = v
    },

    // 棋譜コピーはJS側だけではできないので(recordが空なら)fetchする
    kifu_copy_handle() {
      this.record_fetch(() => this.simple_clipboard_copy(this.record.kif_format_body))
    },

    // ツイートする
    tweet_handle() {
      this.tweet_share_open({url: this.current_url, text: this.hash_tag})
    },

    // 操作←→編集 切り替え
    mode_toggle_handle() {
      if (this.run_mode === "play_mode") {
        this.$gtag.event("open", {event_category: "リレー将棋(編集)"})
        this.run_mode = "edit_mode"
        if (true) {
          this.current_flip = false // ▲視点にしておく(お好み)
        }
      } else {
        this.run_mode = "play_mode"

        // 局面編集から操作モードに戻した瞬間に局面編集モードでの局面を反映しURLを更新する
        // 局面編集モードでの変化をそのまま current_body に反映しない理由は駒箱の駒が消えるため
        // 消えるのはsfenに駒箱の情報が含まれないから
        if (this.development_p && !this.edit_mode_body) {
          alert("edit_mode_body が入っていません")
        }
        this.current_body = this.edit_mode_body
        this.edit_mode_body = null
      }
      this.sound_play("click")
    },

    // private

    record_fetch(callback) {
      if (this.record) {
        callback()
      } else {
        this.record_create(callback)
      }
    },

    // これは汎用のAPIを叩こうかと思ったけど今後の拡張を考えるとこのままでいい気がする
    record_create(callback) {
      const params = new URLSearchParams()
      params.set("body", this.current_body)

      this.http_command("POST", this.$route.path, params, e => {
        if (e.record) {
          this.record = e.record
          callback()
        }
      })
    },

    url_replace() {
      window.history.replaceState("", null, this.current_url)
    },

    // タイトル編集
    title_edit() {
      this.$buefy.dialog.prompt({
        message: "タイトル",
        confirmText: "更新",
        cancelText: "キャンセル",
        inputAttrs: { type: "text", value: this.current_title, required: false },
        onConfirm: value => this.current_title = value,
      })
    },

    // 棋譜読み込みタップ時の処理
    source_read_handle() {
      const body_input_modal = this.$buefy.modal.open({
        parent: this,
        hasModalCard: true,
        animation: "",
        component: {
          template: `
            <div class="modal-card">
              <header class="modal-card-head">
                <p class="modal-card-title">棋譜</p>
              </header>
              <section class="modal-card-body">
                <b-input type="textarea" v-model="any_source" ref="any_source" />
              </section>
              <footer class="modal-card-foot">
                <b-button @click="submit_handle" type="is-primary">読み込む</b-button>
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
            this.http_command("POST", "/api/general/any_source_to", { any_source: any_source, to_format: "sfen" }, e => {
              if (e.body) {
                this.general_ok_notice("正常に読み込みました")
                this.current_body = e.body
                this.turn_offset = e.turn_max
                this.current_flip = false
                body_input_modal.close()
              }
            })
          },
        },
      })
    },

    dynamic_url_for(format = null) {
      const url = new URL(location)
      url.searchParams.set("body", this.edit_mode_body || this.current_body) // 編集モードでもURLを更新するため
      url.searchParams.set("turn", this.turn_offset)
      url.searchParams.set("title", this.current_title)
      if (format) {
        url.searchParams.set("format", format)
      }
      return url.toString()
    },
  },

  computed: {
    current_url() { return this.dynamic_url_for()       },
    json_url()    { return this.dynamic_url_for("json") },
    png_url()     { return this.dynamic_url_for("png")  },

    piyo_shogi_app_with_params_url() { return this.piyo_shogi_full_url(this.current_url, this.turn_offset, this.current_flip) },
    kento_app_with_params_url()      { return this.kento_full_url(this.current_body, this.turn_offset, this.current_flip)  },

    // 最初に表示した手数より進めたか？
    advanced_p() { return this.turn_offset > this.info.record.initial_turn },

    hash_tag() {
      if (this.current_title) {
        return "#" + this.current_title.replace(/\s+/g, "_")
      }
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
  .dropdown_menu, .delete
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
