<template lang="pug">
.AdapterApp
  b-navbar(type="is-primary")
    template(slot="brand")
      b-navbar-item.has-text-weight-bold(tag="div") なんでも棋譜変換
    template(slot="end")
      b-navbar-item(tag="a" href="/") TOP
  .section.pt-5
    .columns
      .column
        b-field.mt-1
          b-input(type="textarea" ref="input_text" v-model="input_text")

        .buttons.are-small.mt-4
          b-button(@click="validate_handle" :icon-left="record ? 'check' : 'doctor'") 検証
          PiyoShogiButton(type="button" @click.prevent="piyo_shogi_open_handle" tag="a" :href="piyo_shogi_app_with_params_url")
          KentoButton(@click.prevent="kento_open_handle" tag="a" :href="kento_app_with_params_url")
          KifCopyButton(@click="kifu_copy_handle('kif')")
          SpShowButton(@click="board_show_handle" v-if="development_p && false")
          b-button(@click.prevent="kifu_paper_handle" icon-left="pdf-box" tag="a" :href="record ? `${$config.BASE_URL}${record.show_path}?formal_sheet=true` : ''") 棋譜用紙
          TweetButton(@click="tweet_handle" :href="record ? tweet_intent_url({text: tweet_body}) : ''")

        .box.is-inline-block.has-background-white-ter.is-shadowless
          table.table.has-background-white-ter.mb-0
            tr
              th.has-text-right コピー
              template(v-for="e in FormatTypeInfo.values")
                td
                  a(@click="kifu_copy_handle(e.key)") {{e.name}}
            tr
              th.has-text-right 表示
              template(v-for="e in FormatTypeInfo.values")
                td
                  a(@click.prevent="kifu_show_handle(e.key)" :href="kifu_show_url(e.key)") {{e.name}}
            tr
              th.has-text-right DL
              template(v-for="e in FormatTypeInfo.values")
                td
                  a(@click.prevent="kifu_dl_handle(e.key)" :href="kifu_dl_url(e.key)") {{e.name}}

          .has-text-centered.mt-3
            b-switch(v-model="body_encode" size="is-small" true-value="sjis" false-value="utf8")
              | 文字コード Shift_JIS

    template(v-if="development_p")
      .columns
        .column
          .box
            .buttons.are-small
              template(v-for="row in test_kifu_body_list")
                .button(@click="input_test_handle(row.input_text)") {{row.name || row.input_text}}
    template(v-if="development_p")
      .columns
        .column
          template(v-if="all_kifs")
            pre {{all_kifs.ki2}}

</template>

<script>
import MemoryRecord from 'js-memory-record'

class FormatTypeInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "kif",  },
      { key: "ki2",  },
      { key: "csa",  },
      { key: "sfen", },
      { key: "bod",  },
      { key: "png",  },
    ]
  }

  get name() {
    return this.key.toUpperCase()
  }
}

export default {
  props: {
    config: { type: Object,  required: true },
  },

  data() {
    return {
      // フォーム関連
      input_text: null,    // 入力した棋譜
      body_encode: "utf8", // ダウンロードするファイルを shift_jis にする？

      // データ
      all_kifs: null, // 変換した棋譜
      record: null,      // FreeBattle のインスタンスの属性たち + いろいろんな情報

      // その他
      change_counter: 0, // 1:更新した状態からはじめる 0:更新してない状態(変更したいとボタンが反応しない状態)
    }
  },

  mounted() {
    // デスクトップのときだけ棋譜のテキストエリアにフォーカス
    this.desktop_focus_to(this.$refs.input_text)

    // ?body=xxx の値を反映する
    this.input_text = this.config.record_attributes.kifu_body || ""
  },

  watch: {
    input_text() {
      this.change_counter += 1
      this.record = null
    },
    body_encode(v) {
      this.sound_play("click")
      if (v === "sjis") {
        this.general_ok_notice("ダウンロードするファイルの文字コードを Shift_JIS に変更します (意味がわからない場合は OFF にしてください)")
      }
    }
  },

  methods: {
    piyo_shogi_open_handle() {
      this.record_fetch(() => this.url_open(this.piyo_shogi_app_with_params_url, this.target_default))
    },

    kento_open_handle() {
      this.record_fetch(() => this.url_open(this.kento_app_with_params_url, this.target_default))
    },

    kifu_copy_handle(kifu_type) {
      this.sound_play("click")
      this.record_fetch(() => {
        if (kifu_type === "png") {
          this.general_ng_notice("画像はコピーできません")
          return
        }
        this.simple_clipboard_copy(this.all_kifs[kifu_type])
      })
    },

    tweet_handle() {
      this.sound_play("click")
      this.record_fetch(() => this.tweet_share_open({text: this.tweet_body}))
    },

    validate_handle() {
      this.sound_play("click")
      this.record_fetch(() => this.general_ok_notice(`${this.record.turn_max}手の棋譜を読み込みました`))
    },

    input_test_handle(input_text) {
      this.input_text = input_text
      this.$nextTick(() => this.validate_handle())
    },

    // 「棋譜印刷」
    kifu_paper_handle() {
      this.record_fetch(() => this.simple_open(`${this.$config.BASE_URL}${this.record.show_path}?formal_sheet=true`))
    },

    // 「KIFダウンロード」
    kifu_dl_handle(kifu_type) {
      this.sound_play("click")
      this.record_fetch(() => this.url_open(this.kifu_dl_url(kifu_type)))
    },

    // 「表示」
    kifu_show_handle(kifu_type) {
      this.sound_play("click")
      this.record_fetch(() => this.simple_open(this.kifu_show_url(kifu_type)))
    },

    // 画像 表示
    // png_show_handle() {
    //   this.record_fetch(() => this.simple_open(this.png_show_url()))
    // },

    // 画像 DL
    // png_dl_handle() {
    //   this.record_fetch(() => this.url_open(this.png_dl_url()))
    // },

    // 「盤面」
    board_show_handle() {
      this.record_fetch(() => this.sp_show_modal({record: this.record, board_show_type: "last"}))
    },

    // helper

    kifu_show_url(kifu_type, other_params = {}) {
      if (this.record) {
        const params = {...other_params}
        if (this.body_encode === "sjis") {
          params["body_encode"] = this.body_encode
        }
        if (kifu_type === "png") {
          params["width"] = 1200
          params["turn"] = this.record.turn_max
        }
        let url = `${this.$config.BASE_URL}${this.record.show_path}.${kifu_type}`

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

    kifu_dl_url(kifu_type) {
      return this.kifu_show_url(kifu_type, {attachment: "true"})
    },

    // png_show_url() {
    //   if (this.record) {
    //     return `${this.$config.BASE_URL}${this.record.show_path}.png?width=1200&turn=${this.record.turn_max}`
    //   }
    // },

    // png_dl_url() {
    //   if (this.record) {
    //     return `${this.$config.BASE_URL}${this.record.show_path}.png?width=1200&turn=${this.record.turn_max}&attachment=true`
    //   }
    // },

    // private

    simple_open(url) {
      this.popup_open(url)
    },

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

      const params = {
        input_text: this.input_text,
        edit_mode: "adapter",
      }
      this.$axios.$post(this.config.post_path, params).then(e => {
        this.change_counter = 0

        this.all_kifs = null

        if (e.redirect_to) {
          if (true) {
            // リダイレクトしたあとブラウザバックで戻ると前の入力が残っている状態になる
            // このとき内部の変数 input_text は空！なので、KENTOを押すと空の棋譜を作って飛んでします
            // それを防ぐためにリダイレクト前に消している
            this.input_text = ""
          }
          this.url_open(e.redirect_to)
        }

        if (e.all_kifs) {
          this.all_kifs = e.all_kifs
        }

        if (e.record) {
          this.record = e.record
          callback()
        }
      })
    },
  },

  computed: {
    FormatTypeInfo() { return FormatTypeInfo },

    //////////////////////////////////////////////////////////////////////////////// piyoshogi

    piyo_shogi_app_with_params_url() {
      if (this.record) {
        return this.piyo_shogi_auto_url({path: this.record.show_path, sfen: this.record.sfen_body, turn: this.record.display_turn, flip: this.record.flip, ...this.record.piyo_shogi_base_params})
      }
    },

    kento_app_with_params_url() {
      if (this.record) {
        return this.kento_full_url({sfen: this.record.sfen_body, turn: this.record.display_turn, flip: this.record.flip})
      }
    },

    tweet_body() {
      if (this.record) {
        return this.as_full_url(this.record.modal_on_index_path)
      }
    },

    //////////////////////////////////////////////////////////////////////////////// test

    test_kifu_body_list() {
      return [
        { name: "正常",       input_text: "68銀、三4歩・☗七九角、8四歩五六歩△85歩78金",                                                                                                                                                                                                                                                                                    },
        { name: "反則",       input_text: "12玉",                                                                                                                                                                                                                                                                                                                           },
        { name: "shogidb2 A", input_text: "https://shogidb2.com/games/018d3d1ee6594c34c677260002621417c8f75221#lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F2P6%2FPP1PPPPPP%2F1B5R1%2FLNSGKGSNL%20w%20-%202",                                                                                                                                                                    },
        { name: "shogidb2 B", input_text: "https://shogidb2.com/board?sfen=lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F2P6%2FPP1PPPPPP%2F1B5R1%2FLNSGKGSNL%20w%20-%202&moves=-3334FU%2B2726FU-8384FU%2B2625FU-8485FU%2B5958OU-4132KI%2B6978KI-8586FU%2B8786FU-8286HI%2B2524FU-2324FU%2B2824HI-8684HI%2B0087FU-0023FU%2B2428HI-2233KA%2B5868OU-7172GI%2B9796FU-3142GI%2B8833UM", },
        { name: "ウォーズ1",  input_text: "https://shogiwars.heroz.jp/games/maosuki-kazookun-20200204_211329?tw=1", },
        { name: "ウォーズ2",  input_text: "https://kif-pona.heroz.jp/games/maosuki-kazookun-20200204_211329?tw=1",  },
        { name: "棋王戦HTML", input_text: "http://live.shogi.or.jp/kiou/kifu/45/kiou202002010101.html", },
        { name: "棋王戦KIF",  input_text: "http://live.shogi.or.jp/kiou/kifu/45/kiou202002010101.kif",  },
      ]
    },
  },
}

</script>

<style lang="sass">
.AdapterApp
  .table
    font-size: $size-7
    tr > *
      border-width: 0
</style>
