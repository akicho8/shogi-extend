<template lang="pug">
.AdapterApp
  DebugBox(v-if="development_p")
    div change_counter: {{change_counter}}

  AdapterSidebar(:base="base")

  MainNavbar
    template(slot="brand")
      NavbarItemHome
      b-navbar-item.has-text-weight-bold(@click="clear_handle") なんでも棋譜変換
    template(slot="end")
      b-navbar-item.px_5_if_tablet(@click="sidebar_toggle")
        b-icon(icon="menu")

  MainSection
    .container
      .columns.is-centered
        .column
          b-field(:type="input_text_field_type")
            b-input(type="textarea" ref="input_text" v-model.trim="input_text" expanded rows="8" placeholder="KIF KI2 CSA SFEN BOD の本体かURL。共有将棋盤・ぴよ将棋・KENTO・lishogi・将棋DB2・将棋ウォーズのURL。棋譜自体を引数に含むURL。棋譜URLをコンテンツに含むサイトURL。戦法名・囲い名などを入力してください")

          b-field.mt-5
            .control
              .buttons.is-centered
                b-button(@click="validate_handle") 検証

          b-field.mt-5
            .control
              .buttons.is-centered
                PiyoShogiButton(type="button" @click.prevent="piyo_shogi_open_handle" tag="a" :href="piyo_shogi_app_with_params_url")
                KentoButton(@click.prevent="kento_open_handle" tag="a" :href="kento_app_with_params_url")
                KifCopyButton(@click="clipboard_open_handle")

      .columns(v-if="record")
        .column
          pre.box.has-background-white-ter
            | {{record.all_kifs.kif}}

  DebugPre(v-if="development_p")
    | {{record}}
</template>

<script>
const AUTO_APP_TO = true

import { support_parent } from "./support_parent.js"
import { app_chore      } from "./app_chore.js"
import { app_sidebar    } from "./app_sidebar.js"
import { FormatTypeInfo } from "@/components/models/format_type_info.js"

import _ from "lodash"

export default {
  name: "AdapterApp",
  mixins: [
    support_parent,
    app_chore,
    app_sidebar,
  ],

  data() {
    return {
      // フォーム関連
      input_text: "",      // 入力した棋譜

      // データ
      record:   null, // FreeBattle のインスタンスの属性たち + いろいろんな情報
      bs_error: null, //  エラー情報

      // その他
      change_counter: 0, // 1:更新した状態からはじめる 0:更新してない状態(変更したいとボタンが反応しない状態)
    }
  },
  mounted() {
    this.ga_click("なんでも棋譜変換")
    this.app_runner()
    this.input_text_focus()
  },
  watch: {
    input_text() {
      this.change_counter += 1
      this.record = null
      this.bs_error = null
      this.swars_url_check()
    },
  },
  methods: {
    swars_url_check() {
      const s = this.input_text
      if (s) {
        const count = (s.match(/\r/g) || 0) + 1
        if (count <= 2) {
          if (s.match(/https.*heroz.jp.*/)) {
            this.toast_ok("将棋ウォーズのURLは将棋ウォーズ棋譜検索の検索欄に入力しても読み込めます")
          }
        }
      }
    },
    input_text_focus() {
      this.desktop_focus_to(this.$refs.input_text)
    },
    clear_handle() {
      if (this.input_text) {
        this.sound_play_click()
        this.input_text = ""
        this.input_text_focus()
      }
    },
    app_open(url) {
      const target = this.target_default_from_params || this.target_default
      this.url_open(url, target)
    },

    //////////////////////////////////////////////////////////////////////////////// open_handle 4種
    piyo_shogi_open_handle() {
      this.record_fetch(() => this.app_open(this.piyo_shogi_app_with_params_url))
    },
    kento_open_handle() {
      this.record_fetch(() => this.app_open(this.kento_app_with_params_url))
    },
    share_board_open_handle() {
      this.record_fetch(() => {
        // https://router.vuejs.org/guide/essentials/navigation.html#programmatic-navigation
        this.$router.push({
          name: "share-board",
          query: {
            body: this.record.all_kifs.sfen,
            turn: this.fixed_turn,
            abstract_viewpoint: "black",
            // title: "共有将棋盤 (棋譜変換後の確認)",
          },
        })
      })
    },
    style_editor_open_handle() {
      this.record_fetch(() => {
        this.$router.push({
          name: "style-editor",
          query: {
            body: this.record.all_kifs.sfen,
          },
        })
      })
    },
    clipboard_open_handle() {
      this.kifu_copy_handle(FormatTypeInfo.fetch('kif'))
    },

    ////////////////////////////////////////////////////////////////////////////////

    kifu_copy_handle(e) {
      this.record_fetch(() => this.simple_clipboard_copy(this.record.all_kifs[e.format_key]))
    },
    validate_handle() {
      this.record_fetch(() => {
        this.toast_ok(`${this.record.turn_max}手の棋譜として読み取りました`)
      })
    },
    input_test_handle(input_text) {
      this.input_text = input_text
      this.$nextTick(() => this.validate_handle())
    },

    // 「棋譜用紙」
    kifu_paper_handle() {
      this.record_fetch(() => {
        this.$router.push({
          name: "adapter-key-formal-sheet",
          params: {
            key: this.record.key,
          },
        })
      })
    },

    // 「動画作成」
    video_new_open_handle() {
      this.record_fetch(() => {
        this.$router.push({
          name: 'video-new',
          query: {
            body: this.record.all_kifs.sfen,
          },
        })
      })
    },

    // 「KIFダウンロード」
    kifu_download_handle(e) {
      this.record_fetch(() => location.href = this.kifu_download_url(e))
    },

    // 「表示」
    kifu_show_handle(e) {
      this.record_fetch(() => {
        const url = this.kifu_show_url(e)
        this.window_popup(url)
      })
    },

    // helper

    kifu_show_url(e, other_params = {}) {
      if (this.record) {
        const params = {...other_params}
        if (e.format_key === "png") {
          params["width"] = 1200
          params["turn"] = this.record.turn_max
        }
        let url = `${this.$config.MY_SITE_URL}${this.show_path}.${e.format_key}`

        // 最後に変換
        const p = new URLSearchParams()
        _.each(params, (v, k) => p.set(k, v))
        const query = p.toString()
        if (query) {
          url += "?" + query
        }

        return url
      }
    },

    kifu_download_url(e) {
      return this.kifu_show_url(e, {attachment: "true", body_encode: e.body_encode})
    },

    // private

    record_fetch(callback) {
      this.sound_play_click()
      if (this.bs_error) {
        this.error_show()
        return
      }
      if (!this.input_text) {
        this.toast_warn("棋譜を入力してください")
        return
      }
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
      this.ga_click("なんでも棋譜変換●")
      const params = {
        input_text: this.input_text,
        edit_mode: "adapter",
        __STATUS_200_IF_ERROR__: true, // エラーをthen側で返す(関係なし)
      }
      const loading = this.$buefy.loading.open()
      this.$axios.$post("/api/adapter/record_create", params).then(e => {
        this.change_counter = 0

        if (e.bs_error) {
          this.bs_error = e.bs_error
          this.error_show()
        }
        if (e.record) {
          this.record = e.record
          this.__assert__(this.record.display_turn != null, "this.record.display_turn != null")
          this.__assert__(this.record.turn_max != null, "this.record.turn_max != null")
          this.__assert__(this.record.piyo_shogi_base_params != null, "this.record.piyo_shogi_base_params != null")
          callback()
        }
      // }).catch(e => {
      //   const bs_error = e.response.data.bs_error
      //   if (bs_error) {
      //     this.bs_error = bs_error
      //     this.error_show()
      //   }
      }).finally(() => {
        loading.close()
      })
    },

    error_show() {
      this.bs_error_message_dialog(this)
    },

    app_runner() {
      const body = this.$route.query.body
      if (this.present_p(body)) {
        this.input_text = body
        this.change_counter += 1

        if (AUTO_APP_TO) {
          let v = this.$route.query.app_to || this.$route.query.open
          if (v) {
            v = _.snakeCase(v)
            const app_to = this[`${v}_open_handle`] // piyo_shogi_open_handle, kento_open_handle, share_board_open_handle
            if (app_to) {
              app_to()
            }
          } else {
            this.validate_handle()
          }
        }
      }
    },
  },

  computed: {
    base() { return this },

    meta() {
      return {
        title: "なんでも棋譜変換",
        description: "将棋倶楽部24や掲示板などで見かける棋譜を外部アプリへ橋渡ししたり、検証・正規化・相互変換ができます",
        og_image_key: "adapter",
      }
    },

    FormatTypeInfo()   { return FormatTypeInfo          },
    show_path()        { return `/x/${this.record.key}` },
    disabled_p()       { return !this.record            },

    input_text_field_type() {
      if (this.bs_error) {
        return "is-danger"
      }
      if (this.record) {
        return "is-success"
      }
    },

    //////////////////////////////////////////////////////////////////////////////// piyo_shogi / kento

    // piyo_shogi, kento, share_board で表示する局面(手数)
    // 中盤開始局面にする場合は this.record.display_turn を渡す
    fixed_turn() {
      return this.record.turn_max // 最終局面
    },

    piyo_shogi_app_with_params_url() {
      if (this.record) {
        return this.piyo_shogi_auto_url({
          ...this.record.piyo_shogi_base_params,
          path: this.show_path,
          sfen: this.record.sfen_body,
          turn: this.fixed_turn,
          viewpoint: this.record.viewpoint,
        })
      }
    },

    kento_app_with_params_url() {
      if (this.record) {
        return this.kento_full_url({
          sfen: this.record.sfen_body,
          turn: this.fixed_turn,
          viewpoint: this.record.viewpoint,
        })
      }
    },

    target_default_from_params() {
      return this.$route.query.open_target
    },
  },
}

</script>

<style lang="sass">
.AdapterApp
  .MainSection.section
    +tablet
      padding: 2rem
</style>
