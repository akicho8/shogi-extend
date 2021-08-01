<template lang="pug">
.GifConvApp
  DebugBox(v-if="development_p")
    div change_counter: {{change_counter}}

  GifConvSidebar(:base="base")

  MainNavbar
    template(slot="brand")
      NavbarItemHome
      b-navbar-item.has-text-weight-bold(@click="clear_handle") タイトルGIF変換
    template(slot="end")
      b-navbar-item.px_5_if_tablet(@click="sidebar_toggle")
        b-icon(icon="menu")

  MainSection
    .container
      .columns.is-centered
        .column.MainColumn
          b-field(:type="input_text_field_type")
            b-input(type="textarea" ref="input_text" v-model.trim="input_text" expanded rows="8" placeholder="KIF KI2 CSA SFEN BOD の中身またはURL。KENTOや将棋DB2のSFEN風パラメータを含むURL。棋譜ファイルへのURLをコンテンツに含むサイトのURL。戦法名・囲い名などを入力してください")

          b-field.mt-5
            .control
              .buttons.is-centered
                b-button(@click="validate_handle") 検証

          b-field.mt-5
            .control
              .buttons.is-centered
                PiyoShogiButton(type="button" @click.prevent="piyo_shogi_open_handle" tag="a" :href="piyo_shogi_app_with_params_url")
                KentoButton(@click.prevent="kento_open_handle" tag="a" :href="kento_app_with_params_url")
                KifCopyButton(@click="kifu_copy_handle(FormatTypeInfo.fetch('kif'))")

      .columns(v-if="record")
        .column
          pre.box.has-background-white-ter
            | {{record.all_kifs.kif}}

      .columns(v-if="development_p")
        .column
          .box
            .buttons.are-small
              template(v-for="row in test_kifu_body_list")
                .button(@click="input_test_handle(row.input_text)") {{row.name}}

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
  name: "GifConvApp",
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
    this.ga_click("タイトルGIF変換")

    if (this.$route.query.body) {
      this.input_text = this.$route.query.body
      this.change_counter += 1

      if (AUTO_APP_TO) {
        let v = this.$route.query.app_to
        if (v) {
          v = _.snakeCase(v)
          const app_to = this[`${v}_open_handle`] // piyo_shogi_open_handle, kento_open_handle, share_board_open_handle
          app_to()
        } else {
          this.validate_handle()
        }
      }
    }

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
        this.sound_play("click")
        this.input_text = ""
        this.input_text_focus()
      }
    },
    app_open(url) {
      this.url_open(url, this.target_default)
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
          name: "gif_conv-key-formal-sheet",
          params: {
            key: this.record.key,
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
      this.sound_play("click")
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
      this.ga_click("タイトルGIF変換●")
      const params = {
        input_text: this.input_text,
        edit_mode: "gif_conv",
        __STATUS_200_IF_ERROR__: true, // エラーをthen側で返す(関係なし)
      }
      const loading = this.$buefy.loading.open()
      this.$axios.$post("/api/gif_conv/record_create", params).then(e => {
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
      // this.bs_error_message_dialog(this.bs_error, this.append_message)
      // this.talk(this.bs_error.message)
      this.bs_error_message_dialog(this.bs_error)
    },
  },

  computed: {
    base() { return this },

    meta() {
      return {
        title: "タイトルGIF変換",
        description: "将棋倶楽部24や掲示板などで見かける棋譜を外部アプリへ橋渡ししたり、検証・正規化・相互変換ができます",
        og_image_key: "gif_conv",
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

    append_message() {
      const tag = `<a href="https://twitter.com/sgkinakomochi" target="_blank">@sgkinakomochi</a>`
      return `<div class="mt-2">正しいのに読み込めないときは ${tag} までご一報ください</div>`
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

    //////////////////////////////////////////////////////////////////////////////// test

    test_kifu_body_list() {
      return [
        { name: "正常",       input_text: "68銀、三4歩・☗七九角、8四歩五六歩△85歩78金",                                                                                                                                                                                                                                                                                    },
        { name: "反則1",      input_text: "12玉",                                                                                                                                                                                                                                                                                                                           },
        { name: "反則2",      input_text: "V2,P1 *,+0093KA,T1",                                                                                                                                                                                                                                                                                                                           },
        { name: "shogidb2 A", input_text: "https://shogidb2.com/games/018d3d1ee6594c34c677260002621417c8f75221#lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F2P6%2FPP1PPPPPP%2F1B5R1%2FLNSGKGSNL%20w%20-%202",                                                                                                                                                                    },
        { name: "shogidb2 B", input_text: "https://shogidb2.com/board?sfen=lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F2P6%2FPP1PPPPPP%2F1B5R1%2FLNSGKGSNL%20w%20-%202&moves=-3334FU%2B2726FU-8384FU%2B2625FU-8485FU%2B5958OU-4132KI%2B6978KI-8586FU%2B8786FU-8286HI%2B2524FU-2324FU%2B2824HI-8684HI%2B0087FU-0023FU%2B2428HI-2233KA%2B5868OU-7172GI%2B9796FU-3142GI%2B8833UM", },
        { name: "ウォーズ1",  input_text: "https://shogiwars.heroz.jp/games/Kato_Hifumi-SiroChannel-20200927_180900?tw=1", },
        { name: "ウォーズ2",  input_text: "https://kif-pona.heroz.jp/games/Kato_Hifumi-SiroChannel-20200927_180900?tw=1",  },
        { name: "棋王戦HTML", input_text: "http://live.shogi.or.jp/kiou/kifu/45/kiou202002010101.html", },
        { name: "棋王戦KIF",  input_text: "http://live.shogi.or.jp/kiou/kifu/45/kiou202002010101.kif",  },
      ]
    },
  },
}

</script>

<style lang="sass">
.GifConvApp
  .MainSection.section
    +tablet
      padding: 2rem

  .MainColumn
    // +tablet
    //   max-width: 40rem

</style>
