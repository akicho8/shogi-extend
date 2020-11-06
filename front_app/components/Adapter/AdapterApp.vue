<template lang="pug">
.AdapterApp
  DebugBox
    div change_counter: {{change_counter}}

  b-sidebar.AdapterApp-Sidebar.is-unselectable(fullheight right v-model="sidebar_p")
    .mx-4.my-4
      b-menu
        b-menu-list(label="Action")
          b-menu-item(@click="board_show_handle" label="共有将棋盤に転送")

        b-menu-list(label="Export")
          b-menu-item(@click="kifu_paper_handle" label="棋譜印刷 (PDF)")
          b-menu-item(:expanded="false" @click="sound_play('click')")
            template(slot="label" slot-scope="props")
              | 表示
              b-icon.is-pulled-right(:icon="props.expanded ? 'menu-up' : 'menu-down'")
            template(v-for="e in FormatTypeInfo.values")
              b-menu-item(:label="e.name" @click.prevent="kifu_show_handle(e.key)" :href="kifu_show_url(e.key)")
          b-menu-item(@click="sound_play('click')")
            template(slot="label" slot-scope="props")
              | コピー
              b-icon.is-pulled-right(:icon="props.expanded ? 'menu-up' : 'menu-down'")
            template(v-for="e in FormatTypeInfo.values")
              template(v-if="e.clipboard_copyable")
                b-menu-item(:label="e.name" @click="kifu_copy_handle(e.key)")
          b-menu-item(@click="sound_play('click')")
            template(slot="label" slot-scope="props")
              | ダウンロード
              b-icon.is-pulled-right(:icon="props.expanded ? 'menu-up' : 'menu-down'")
            template(v-for="e in DlFormatTypeInfo.values")
              b-menu-item(:label="e.name" @click.prevent="kifu_dl_handle(e)" :href="kifu_dl_url(e)")

        b-menu-list(label="ANOTHER")
          b-menu-item(label="対応フォーマット" tag="nuxt-link" :to="{name: 'adapter-description'}" @click.native="sound_play('click')")

  MainNavbar
    template(slot="brand")
      NavbarItemHome
      b-navbar-item.has-text-weight-bold(@click="clear_handle") なんでも棋譜変換
    template(slot="end")
      b-navbar-item(@click="sidebar_toggle")
        b-icon(icon="menu")

  MainSection
    .container
      .columns.is-centered
        .column.MainColumn
          b-field(:type="input_text_field_type")
            b-input(type="textarea" ref="input_text" v-model.trim="input_text" expanded rows="8")

          b-field.mt-5
            .control
              .buttons.is-centered
                b-button(@click="validate_handle") 検証

          b-field.mt-5
            .control
              .buttons.is-centered
                PiyoShogiButton(type="button" @click.prevent="piyo_shogi_open_handle" tag="a" :href="piyo_shogi_app_with_params_url")
                KentoButton(@click.prevent="kento_open_handle" tag="a" :href="kento_app_with_params_url")
                KifCopyButton(@click="kifu_copy_handle('kif')")

      .columns(v-if="record")
        .column
          pre.box.has-background-success-light
            | {{record.all_kifs.kif}}

      .columns(v-if="development_p")
        .column
          .box
            .buttons.are-small
              template(v-for="row in test_kifu_body_list")
                .button(@click="input_test_handle(row.input_text)") {{row.name}}

  DebugPre(v-if="record") {{record}}
</template>

<script>
import MemoryRecord from 'js-memory-record'

class FormatTypeInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "kif",  clipboard_copyable: true,  },
      { key: "ki2",  clipboard_copyable: true,  },
      { key: "csa",  clipboard_copyable: true,  },
      { key: "sfen", clipboard_copyable: true,  },
      { key: "bod",  clipboard_copyable: true,  },
      { key: "png",  clipboard_copyable: false, },
    ]
  }

  get name() {
    return this.key.toUpperCase()
  }
}

class DlFormatTypeInfo extends MemoryRecord {
  static get define() {
    return [
      { name: "KIF",        format_key: "kif",  body_encode: "utf8",  },
      { name: "KIF (SJIS)", format_key: "kif",  body_encode: "sjis",  },
      { name: "KI2",        format_key: "ki2",  body_encode: "utf8",  },
      { name: "CSA",        format_key: "csa",  body_encode: "utf8",  },
      { name: "SFEN",       format_key: "sfen", body_encode: "utf8",  },
      { name: "BOD",        format_key: "bod",  body_encode: "utf8",  },
      { name: "PNG",        format_key: "png",                        },
    ]
  }
}

class EncodeInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "utf8", name: "UTF-8",     },
      { key: "sjis", name: "Shift_JIS", },
    ]
  }
}

export default {
  name: "AdapterApp",
  data() {
    return {
      // フォーム関連
      input_text: "",      // 入力した棋譜

      // データ
      record:   null, // FreeBattle のインスタンスの属性たち + いろいろんな情報
      bs_error: null, //  エラー情報

      // その他
      change_counter: 0, // 1:更新した状態からはじめる 0:更新してない状態(変更したいとボタンが反応しない状態)
      sidebar_p: false,
    }
  },
  mounted() {
    this.ga_click("なんでも棋譜変換")

    if (this.$route.query.body) {
      this.input_text = this.$route.query.body
      this.change_counter += 1
      this.validate_handle()
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
        this.sound_play('click')
        this.input_text = ""
        this.input_text_focus()
      }
    },
    app_open(url) {
      this.url_open(url, this.target_default)
    },
    sidebar_toggle() {
      this.sound_play('click')
      this.sidebar_p = !this.sidebar_p
    },
    piyo_shogi_open_handle() {
      this.record_fetch(() => this.app_open(this.piyo_shogi_app_with_params_url))
    },
    kento_open_handle() {
      this.record_fetch(() => this.app_open(this.kento_app_with_params_url))
    },
    kifu_copy_handle(kifu_type) {
      this.record_fetch(() => this.simple_clipboard_copy(this.record.all_kifs[kifu_type]))
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

    // 「棋譜印刷」
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

    // 「KIFダウンロード」
    kifu_dl_handle(e) {
      this.record_fetch(() => this.app_open(this.kifu_dl_url(e)))
    },

    // 「表示」
    kifu_show_handle(kifu_type) {
      this.record_fetch(() => {
        const url = this.kifu_show_url(kifu_type)
        this.window_popup(url)
      })
    },

    // 「盤面」
    board_show_handle() {
      this.record_fetch(() => {
        // https://router.vuejs.org/guide/essentials/navigation.html#programmatic-navigation
        this.$router.push({
          name: "share-board",
          query: {
            body: this.record.all_kifs.sfen,
            image_view_point: "black",
            // title: "共有将棋盤 (棋譜変換後の確認)",
          },
        })
      })
    },

    // helper

    kifu_show_url(kifu_type, other_params = {}) {
      if (this.record) {
        const params = {...other_params}
        if (kifu_type === "png") {
          params["width"] = 1200
          params["turn"] = this.record.turn_max
        }
        let url = `${this.$config.MY_SITE_URL}${this.show_path}.${kifu_type}`

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

    kifu_dl_url(e) {
      return this.kifu_show_url(e.format_key, {attachment: "true", body_encode: e.body_encode})
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
      this.ga_click("なんでも棋譜変換●")
      const params = {
        input_text: this.input_text,
        edit_mode: "adapter",
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
          callback()
        }
      }).finally(() => {
        loading.close()
      })
    },

    error_show() {
      this.bs_error_message_dialog(this.bs_error, this.append_message)
      this.talk(this.bs_error.message)
    },
  },

  computed: {
    meta() {
      return {
        title: "なんでも棋譜変換",
        description: "将棋倶楽部24や掲示板などで見かける棋譜を外部アプリへ橋渡ししたり、検証・正規化・相互変換ができます",
        og_image_key: "adapter",
      }
    },

    FormatTypeInfo() { return FormatTypeInfo          },
    DlFormatTypeInfo() { return DlFormatTypeInfo          },
    EncodeInfo()     { return EncodeInfo              },
    show_path()      { return `/x/${this.record.key}` },
    disabled_p()     { return !this.record            },

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

    //////////////////////////////////////////////////////////////////////////////// piyoshogi

    piyo_shogi_app_with_params_url() {
      if (this.record) {
        return this.piyo_shogi_auto_url({
          ...this.record.piyo_shogi_base_params,
          path: this.show_path,
          sfen: this.record.sfen_body,
          turn: this.record.display_turn,
          flip: this.record.flip,
        })
      }
    },

    kento_app_with_params_url() {
      if (this.record) {
        return this.kento_full_url({
          sfen: this.record.sfen_body,
          turn: this.record.display_turn,
          flip: this.record.flip,
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
.AdapterApp-Sidebar
  .sidebar-content
    // width: unset
    // a
    //   white-space: nowrap
    .menu-label:not(:first-child)
      margin-top: 2em

.AdapterApp
  .MainColumn
    +tablet
      max-width: 65ch
</style>
