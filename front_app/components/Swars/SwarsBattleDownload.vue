<template lang="pug">
.SwarsBattleDownload
  b-loading(:active="$fetchState.pending")

  MainNavbar
    template(slot="brand")
      b-navbar-item(@click="back_handle")
        b-icon(icon="chevron-left")
      b-navbar-item.has-text-weight-bold.is-size-7-mobile(tag="div") {{page_title}}
    template(slot="end")
      NavbarItemLogin
      NavbarItemProfileLink

  MainSection(v-if="config")
    .container
      .level.has-background-primary-light.py-5.box.is-shadowless
        .level-item.has-text-centered
          div
            p.heading 検索キーワード
            p.title.is-size-6-mobile
              | {{current_params.query}}
        .level-item.has-text-centered
          div
            p.heading 順序
            p.title.is-size-6-mobile
              | {{Dictionary.fetch(current_params.sort_column).name}}{{Dictionary.fetch(current_params.sort_order).name}}

      b-field(label="対象" custom-class="is-small" :message="current_scope_info.message")
        template(v-for="e in config.scope_info")
          b-radio-button(size="is-small" v-model="zip_dl_scope_key" :native-value="e.key" @input="zip_dl_scope_key_change_handle")
            | {{e.name}}
            template(v-if="e.count >= 1")
              b-tag.has-text-weight-bold.ml-1(rounded type="is-primary is-light") {{e.count}}

      b-field(label="フォーマット" custom-class="is-small")
        template(v-for="e in ZipDlFormatInfo.values")
          b-radio-button(size="is-small" v-model="zip_dl_format_key" :native-value="e.key" @input="zip_dl_format_key_change_handle")
            | {{e.name}}

      b-field(label="文字コード" custom-class="is-small")
        template(v-for="e in BodyEncodeInfo.values")
          b-radio-button(size="is-small" v-model="body_encode" :native-value="e.key" @input="body_encode_change_handle")
            | {{e.name}}

      b-field.zip_dl_max(label="件数最大" custom-class="is-small" v-if="development_p")
        b-radio-button(size="is-small" v-model="zip_dl_max" :native-value="0" @input="sound_play('click')")   0
        b-radio-button(size="is-small" v-model="zip_dl_max" :native-value="1" @input="sound_play('click')")   1
        b-radio-button(size="is-small" v-model="zip_dl_max" :native-value="50" @input="sound_play('click')") 50

      hr

      .buttons
        b-button(@click="download_handle" :loading="loading_p" icon-left="download") ダウンロード
        b-button(@click="swars_zip_dl_logs_destroy_all" v-if="development_p") クリア
        b-button(@click="oldest_log_create_handle" v-if="development_p") 古い1件をDLしたことにする

  DebugPre {{$data}}
  //- DebugPre(v-if="!$fetchState.pending") {{ls_default}}
</template>

<script>
import ls_support from "@/components/models/ls_support.js"
import { isMobile } from "@/components/models/isMobile.js"
import { Dictionary } from "@/components/models/Dictionary.js"

import MemoryRecord from "js-memory-record"

// class ScopeInfo extends MemoryRecord {
//   static get define() {
//     return [
//       { key: "latest",    name: "直近",           },
//       { key: "today",     name: "本日分",         },
//       { key: "continue",  name: "前回の続きから", },
//     ]
//   }
// }

class ZipDlFormatInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "kif",  },
      { key: "ki2",  },
      { key: "csa",  },
      { key: "sfen", },
    ]
  }

  get name() {
    return this.key.toUpperCase()
  }
}

class BodyEncodeInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "UTF-8",     },
      { key: "Shift_JIS", },
    ]
  }
}

export default {
  name: "SwarsBattleDownload",
  mixins: [ls_support],
  data() {
    return {
      // for ls_support
      zip_dl_scope_key:  null,
      zip_dl_format_key: null,
      body_encode: null,
      zip_dl_max: null,

      config: null,
      loading_p: false,
    }
  },

  fetchOnServer: false,
  fetch() {
    if (true) {
      const e = this.current_params
      if (e.query && e.sort_column && e.sort_order) {
      } else {
        this.$nuxt.error({statusCode: 500, message: "パラメータが足りません"})
        return
      }
    }

    const params = {
      ...this.current_params,
      download_config_fetch: "true",
    }
    return this.$axios.$get("/w.json", {params: params}).then(e => {
      this.config = e
      // this.ls_reset()
      this.ls_setup()
    })
  },

  methods: {
    back_handle() {
      this.sound_play("click")
      this.back_to({name: "swars-search", query: this.current_params})
    },

    zip_dl_scope_key_change_handle(v) {
      this.sound_play("click")
      this.talk(v)

      if (v === "zdsk_continue") {
        if (!this.g_current_user) {
          if (false) {
            this.talk_stop()
            this.toast_ok("前回の続きからダウンロードするにはいったんログインして、そのあと初回だけ「前回の続きから」以外の方法でダウンロードしてください。そうすると使えるようになります")
          }
        }
      }
    },
    zip_dl_format_key_change_handle(v) {
      this.sound_play("click")
      this.talk(v)
      if (v === "sfen" && false) {
        this.toast_ok("よくわからない場合は KIF にしてください")
      }
    },
    body_encode_change_handle(v) {
      this.sound_play("click")
      this.talk(v)
      if (v === "Shift_JIS" && false) {
        this.toast_ok("ShogiGUI で連続棋譜解析する場合はこっち")
      }
    },

    download_handle() {
      this.sound_play("click")

      if (this.current_scope_info.count === 0) {
        this.toast_warn("データがありません")
        return
      }

      const params = {
        ...this.current_params,
        zip_dl_scope_key:  this.zip_dl_scope_key,
        zip_dl_format_key: this.zip_dl_format_key,
        zip_dl_max:        this.zip_dl_max,
        body_encode:       this.body_encode,
      }

      const usp = new URLSearchParams()
      _.each(params, (v, k) => usp.set(k, v))
      const url = this.$config.MY_SITE_URL + `/w.zip?${usp}`

      if (false) {
        // この順で実行するとなんと location.href が無かったことにされる
        location.href = url
        this.back_handle()
      } else {
        // 別枠でダウンロードさせるとこちら側は自由に動ける
        this.other_window_open(url)
        this.back_handle() // 連打対策も兼ねて一覧に戻す
      }

      if (false) {
        this.loading_p = true
        this.delay_block(3, () => {
          this.loading_p = false
          this.$fetch()

          this.toast_ok(`たぶんダウンロード完了しました`, {
            onend: () => {
              this.toast_ok(`もっとたくさん取得したいときは「古い棋譜を補完」のほうを使ってください`)
            },
          })
        })
      }
    },

    //////////////////////////////////////////////////////////////////////////////// デバッグ用

    async swars_zip_dl_logs_destroy_all() {
      await this.$axios.$get("/w.json", {params: {swars_zip_dl_logs_destroy_all: "true"}})
      this.$fetch()
    },

    async oldest_log_create_handle() {
      await this.$axios.$get("/w.json", {params: {...this.current_params, oldest_log_create: "true"}})
      this.$fetch()
    },
  },
  computed: {
    meta() {
      return {
        title: this.page_title,
        og_title: this.page_title,
        og_description: "",
      }
    },

    page_title() {
      return `棋譜ダウンロード`
    },

    ////////////////////////////////////////////////////////////////////////////////
    ZipDlFormatInfo() { return ZipDlFormatInfo },
    BodyEncodeInfo()  { return BodyEncodeInfo  },
    Dictionary()      { return Dictionary      },

    current_params()     { return this.$route.query },
    current_scope_info() { return this.config.scope_info[this.zip_dl_scope_key] },

    //////////////////////////////////////////////////////////////////////////////// for ls_support
    ls_storage_key() {
      return "swars_download_params"
    },
    ls_default() {
      return { ...this.config.form_params_default }
    },
  },
}
</script>

<style lang="sass">
.SwarsBattleDownload
  .MainSection
    +mobile
      padding: 1.4rem 1.5rem

    .container
      max-width: 65ch

    .field:not(:last-child)
      margin-bottom: 1.5rem

    .buttons
      +mobile
        justify-content: center

    // buefy の不具合で b-radio-button が1つのとき最大横幅になる対策
    .zip_dl_max
      max-width: 3rem

    .level
      .title
        font-size: $size-5

    .tag
      font-size: 0.6rem
</style>
