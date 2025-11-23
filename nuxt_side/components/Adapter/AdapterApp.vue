<template lang="pug">
// meta タグは重要なだけで SSR である効果はあまりない
// また client-only な部分を server で実行してしまう恐れがあるため入れている
client-only
  .AdapterApp
    DebugBox(v-if="development_p")
      div change_counter: {{change_counter}}

    AdapterSidebar(:base="base")

    MainNavbar
      template(slot="brand")
        NavbarItemHome
        b-navbar-item.has-text-weight-bold(@click="clear_handle") なんでも棋譜変換
      template(slot="end")
        NavbarItemSidebarOpen(@click="sidebar_toggle")

    MainSection
      .container
        .columns.is-centered
          .column
            b-field(:type="input_text_field_type")
              b-input(type="textarea" ref="input_text" v-model.trim="input_text" expanded rows="8" :placeholder="SHARED_STRING.kifu_body_placeholder")

            b-field.mt-5
              .control
                .buttons.is-centered
                  b-button(@click="validate_handle") 検証
                  //- b-button(@click="share_board_open_handle") 盤面

            b-field.mt-5
              .control
                .buttons.is-centered
                  PiyoShogiButton(type="button" @click.prevent="piyo_shogi_open_handle" tag="a" :href="current_kifu_vo && current_kifu_vo.piyo_url")
                  KentoButton(@click.prevent="kento_open_handle" tag="a" :href="current_kifu_vo && current_kifu_vo.kento_url")
                  KifCopyButton(@click="clipboard_open_handle")

            b-field.mt-5
              .control
                .buttons.is-centered.are-small
                  b-button(@click="share_board_first_open_handle") 最初の局面
                  b-button(@click="share_board_last_open_handle") 最後の局面

            b-field.mt-5
              .control
                .buttons.is-centered.are-small
                  b-button(@click="kifu_dl_handle_of(FormatTypeInfo.fetch('kif_utf8'))"     tag="a" :href="kifu_dl_url_of(FormatTypeInfo.fetch('kif_utf8'))") 保存
                  b-button(@click="kifu_dl_handle_of(FormatTypeInfo.fetch('kif_shiftjis'))" tag="a" :href="kifu_dl_url_of(FormatTypeInfo.fetch('kif_shiftjis'))") 保存 (Shift_JIS)

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
import { mod_chore      } from "./mod_chore.js"
import { mod_sidebar    } from "./mod_sidebar.js"
import { FormatTypeInfo } from "@/components/models/format_type_info.js"
import { SafeSfen } from "@/components/models/safe_sfen.js"
import QueryString from "query-string"

import _ from "lodash"

export default {
  name: "AdapterApp",
  mixins: [
    support_parent,
    mod_chore,
    mod_sidebar,
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
    this.app_log("なんでも棋譜変換")
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
          if (s.includes("shogiwars.heroz.jp/games/")) {
            this.toast_primary("将棋ウォーズのURLは将棋ウォーズ棋譜検索の検索欄に入力しても読み込めます")
          }
          if (false) {
            if (s.includes("/kifu.questgames.net/shogi/games/")) {
              this.toast_warn("将棋クエストのURLには対応していません")
            }
          }
        }
      }
    },
    input_text_focus() {
      this.desktop_focus_to(this.$refs.input_text)
    },
    clear_handle() {
      if (this.input_text) {
        this.sfx_click()
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
      this.record_fetch(() => this.app_open(this.current_kifu_vo.piyo_url))
    },
    kento_open_handle() {
      this.record_fetch(() => this.app_open(this.current_kifu_vo.kento_url))
    },
    share_board_open_handle() {
      this.share_board_open_handle_by(null)
    },
    share_board_first_open_handle() {
      this.share_board_open_handle_by(0)
    },
    share_board_last_open_handle() {
      this.share_board_open_handle_by(null)
    },
    share_board_open_handle_by(force_turn) {
      this.record_fetch(() => {
        // https://router.vuejs.org/guide/essentials/navigation.html#programmatic-navigation
        this.$router.push({
          name: "share-board",
          query: {
            xbody: SafeSfen.encode(this.record.all_kifs.sfen),
            turn: force_turn ?? this.fixed_turn,
            viewpoint: "black",
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
      this.kifu_copy_handle(FormatTypeInfo.fetch('kif_utf8'))
    },

    ////////////////////////////////////////////////////////////////////////////////

    kifu_copy_handle(e) {
      this.record_fetch(() => this.clipboard_copy(this.record.all_kifs[e.format_key]))
    },
    validate_handle() {
      this.record_fetch(() => {
        this.toast_primary(`${this.record.turn_max}手の棋譜として読み取りました`)
      })
    },
    input_test_handle(input_text) {
      this.input_text = input_text
      this.$nextTick(() => this.validate_handle())
    },

    // 「棋譜用紙」
    print_open_handle() {
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
    kifu_dl_handle_of(e) {
      this.record_fetch(() => location.href = this.kifu_dl_url_of(e))
    },

    // 「表示」
    kifu_show_handle_of(e) {
      this.record_fetch(() => {
        const url = this.kifu_show_url_of(e)
        this.window_popup(url)
      })
    },

    // helper

    kifu_show_url_of(e, other_params = {}) {
      if (this.record) {
        const params = {...other_params}
        if (e.format_key === "png") {
          params["width"] = 1200
          params["turn"] = this.record.turn_max
        }
        return QueryString.stringifyUrl({
          url: `${this.$config.MY_SITE_URL}${this.show_path}.${e.format_key}`,
          query: params,
        })
      }
    },

    kifu_dl_url_of(e) {
      return this.kifu_show_url_of(e, {disposition: "attachment", body_encode: e.body_encode})
    },

    // private

    record_fetch(callback) {
      this.sfx_click()
      if (this.bs_error) {
        this.error_show()
        return
      }
      if (!this.input_text) {
        this.toast_warn("棋譜を入力しよう")
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
      this.app_log("なんでも棋譜変換●")
      const params = {
        input_text: this.input_text,
        edit_mode: "adapter",
        __ERROR_THEN_STATUS_200__: true, // エラーをthen側で返す(関係なし)
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
          this.$GX.assert(this.record.display_turn != null, "this.record.display_turn != null")
          this.$GX.assert(this.record.turn_max != null, "this.record.turn_max != null")
          this.$GX.assert(this.record.piyo_shogi_base_params != null, "this.record.piyo_shogi_base_params != null")
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
      if (this.$GX.present_p(body)) {
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
      let max = 0
      if (this.record) {
        max = this.record.turn_max
      }

      const turn = this.query_to_turn(this.$route.query, max)
      if (turn != null) {
        return turn
      }

      return max
    },

    current_kifu_vo() {
      if (this.record) {
        return this.$KifuVo.create({
          kif_url: `${this.$config.MY_SITE_URL}${this.show_path}.kif`,
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
