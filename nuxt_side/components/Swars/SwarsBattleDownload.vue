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
      template(v-if="config.limiter.over_p")
        b-notification(type="is-warning" :closable="false")
          | {{config.limiter.message}}

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
              | {{current_params.sort_column}} {{current_params.sort_order}}

      b-field(label="範囲" custom-class="is-small" :message="current_zip_dl_scope_info.message")
        template(v-for="e in config.scope_info")
          b-radio-button(size="is-small" v-model="zip_dl_scope_key" :native-value="e.key" :class="e.key" @input="zip_dl_scope_key_change_handle")
            | {{e.name}}
            template(v-if="e.count >= 1 || true")
              b-tag.has-text-weight-bold.ml-1(rounded type="is-primary is-light") {{e.count}}

      b-field(label="フォーマット" custom-class="is-small" :message="current_zip_dl_format_info.message")
        template(v-for="e in ZipDlFormatInfo.values")
          b-radio-button(size="is-small" v-model="zip_dl_format_key" :native-value="e.key" @input="zip_dl_format_key_change_handle")
            | {{e.name}}

      b-field(label="文字コード" custom-class="is-small" :message="current_body_encode_info.message")
        template(v-for="e in BodyEncodeInfo.values")
          b-radio-button(size="is-small" v-model="body_encode" :native-value="e.key" @input="body_encode_change_handle")
            | {{e.name}}

      b-field.zip_dl_max(label="最大件数" custom-class="is-small" :message="current_zip_dl_max_info.message")
        template(v-for="e in ZipDlMaxInfo.values")
          b-radio-button(size="is-small" v-model="zip_dl_max" :native-value="e.value" @input="zip_dl_max_change_handle")
            | {{e.name}}
      //- b-field.zip_dl_max(label="最大件数" custom-class="is-small" message="これ以上一気にダウンロードするときは「古い棋譜を補完」のほうを使ってください")
      //-   //- b-radio-button(size="is-small" v-model="zip_dl_max" :native-value="0" @input="$sound.play_click()" v-if="development_p")   0
      //-   //- b-radio-button(size="is-small" v-model="zip_dl_max" :native-value="1" @input="$sound.play_click()" v-if="development_p")   1
      //-   b-radio-button(size="is-small" v-model="zip_dl_max" :native-value="50" @input="$sound.play_click()") 50

      b-field(label="ZIPの構造" custom-class="is-small" :message="current_zip_dl_structure_info.message")
        template(v-for="e in ZipDlStructureInfo.values")
          b-radio-button(size="is-small" v-model="zip_dl_structure_key" :native-value="e.key" @input="zip_dl_structure_key_change_handle")
            | {{e.name}}
      hr

      .buttons
        b-button.download_handle(@click="download_handle" :loading="loading_p" icon-left="download") ダウンロード
        b-button.swars_zip_dl_logs_destroy_all(@click="swars_zip_dl_logs_destroy_all" v-if="development_p") クリア
        b-button.oldest_log_create_handle(@click="oldest_log_create_handle" v-if="development_p") 古い1件をDLしたことにする

  DebugPre(v-if="development_p") {{$data}}
</template>

<script>
import { ls_support_mixin } from "@/components/models/ls_support_mixin.js"
import { MyMobile } from "@/components/models/my_mobile.js"
const QueryString = require("query-string")

// import { Dictionary } from "@/components/models/dictionary.js"

import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

// class ScopeInfo extends ApplicationMemoryRecord {
//   static get define() {
//     return [
//       { key: "latest",    name: "直近",           },
//       { key: "today",     name: "本日分",         },
//       { key: "continue",  name: "前回の続きから", },
//     ]
//   }
// }

import { ZipDlFormatInfo    } from "@/components/models/zip_dl_format_info.js"
import { BodyEncodeInfo     } from "@/components/models/body_encode_info.js"
import { ZipDlMaxInfo       } from "@/components/models/zip_dl_max_info.js"
import { ZipDlStructureInfo } from "@/components/models/zip_dl_structure_info.js"

export default {
  name: "SwarsBattleDownload",
  mixins: [ls_support_mixin],
  data() {
    return {
      // for ls_support_mixin
      zip_dl_scope_key:  null,
      zip_dl_format_key: null,
      body_encode: null,
      zip_dl_max: null,
      zip_dl_structure_key: null,

      config: null,
      loading_p: false,
    }
  },

  fetchOnServer: false,
  fetch() {
    if (this.nuxt_login_required()) { return }

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
      this.$sound.play_click()
      this.back_handle2()
    },
    back_handle2() {
      this.back_to({name: "swars-search", query: this.current_params})
    },

    zip_dl_scope_key_change_handle(v) {
      this.$sound.play_click()
      this.talk(this.current_zip_dl_scope_info.name)

      if (v === "zdsk_continue") {
        if (!this.g_current_user) {
          if (false) {
            this.$sound.stop_all()
            this.toast_ok("前回の続きからダウンロードするにはいったんログインして、そのあと初回だけ「前回の続きから」以外の方法でダウンロードしてください。そうすると使えるようになります")
          }
        }
      }
    },
    zip_dl_format_key_change_handle(v) {
      this.$sound.play_click()
      this.talk(this.current_zip_dl_format_info.name)
      if (v === "sfen" && false) {
        this.toast_ok("よくわからない場合は KIF にしてください")
      }
    },
    zip_dl_max_change_handle(v) {
      this.$sound.play_click()
      this.talk(this.current_zip_dl_max_info.name)
    },
    body_encode_change_handle(v) {
      this.$sound.play_click()
      this.talk(this.current_body_encode_info.name)
      if (v === "Shift_JIS" && false) {
        this.toast_ok("ShogiGUI で連続棋譜解析する場合はこっち")
      }
    },
    zip_dl_structure_key_change_handle(v) {
      this.$sound.play_click()
      this.talk(this.current_zip_dl_structure_info.name)
    },

    download_handle() {
      this.$sound.play_click()

      if (this.current_zip_dl_scope_info.count === 0) {
        this.toast_warn("データがありません")
        return
      }

      const params = {
        ...this.current_params,
        zip_dl_scope_key:  this.zip_dl_scope_key,
        zip_dl_format_key: this.zip_dl_format_key,
        zip_dl_max:        this.zip_dl_max,
        zip_dl_structure_key:          this.zip_dl_structure_key,
        body_encode:       this.body_encode,
      }

      const url = QueryString.stringifyUrl({url: `${this.$config.MY_SITE_URL}/w.zip`, query: params})

      if (false) {
        // この順で実行するとなんと location.href が無かったことにされる
        location.href = url
        this.back_handle2()
      } else {
        // 別枠でダウンロードさせるとこちら側は自由に動ける
        this.other_window_open(url)
        this.back_handle2() // 連打対策も兼ねて一覧に戻す
      }

      if (false) {
        this.loading_p = true
        this.$gs.delay_block(3, () => {
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
    ZipDlFormatInfo()    { return ZipDlFormatInfo                                                },
    BodyEncodeInfo()     { return BodyEncodeInfo                                                 },
    ZipDlStructureInfo() { return ZipDlStructureInfo                                             },
    ZipDlMaxInfo()       { return ZipDlMaxInfo                                                   },

    current_params()                { return this.$route.query                                   },
    current_zip_dl_scope_info()     { return this.config.scope_info[this.zip_dl_scope_key]       },
    current_zip_dl_format_info()    { return ZipDlFormatInfo.fetch(this.zip_dl_format_key)       },
    current_zip_dl_structure_info() { return ZipDlStructureInfo.fetch(this.zip_dl_structure_key) },
    current_zip_dl_max_info()       { return ZipDlMaxInfo.fetch(this.zip_dl_max.toString())      },
    current_body_encode_info()      { return BodyEncodeInfo.fetch(this.body_encode)              },

    //////////////////////////////////////////////////////////////////////////////// for ls_support_mixin
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
  .MainSection.section
    +tablet
      padding: 2rem
    +mobile
      padding: 1.5rem

    .container
      max-width: 40rem

    .field:not(:last-child)
      margin-bottom: 1.5rem

    .buttons
      +mobile
        justify-content: center

    // buefy の不具合で b-radio-button が1つのとき最大横幅になる対策
    .zip_dl_max
      .b-radio
        width: 3rem

    .level
      .title
        font-size: $size-5

    .tag
      font-size: 0.6rem
</style>
