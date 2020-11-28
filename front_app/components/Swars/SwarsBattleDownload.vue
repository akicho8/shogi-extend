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
      template(v-if="!g_current_user && false")
        b-notification(type="is-info is-light")
          .is-size-7-mobile
            | ログインしていると「前回の続きから」を選択できます

      //- b-notification(:closable="false" type="is-primary is-light")
      //-   .is-size-7-mobile
      //-     span 検索条件:
      //-     span.has-text-weight-bold.ml-1 {{current_params.query}}<br>
      //-     span 並び替え:
      //-     span.ml-1 {{Dictionary.fetch(current_params.sort_column).name}}{{Dictionary.fetch(current_params.sort_order).name}}

      //- .level.is-mobile.has-background-primary-light.py-4.box
      .level.is-mobile.has-background-primary-light.py-5.box.is-shadowless
        .level-item.has-text-centered
          div
            p.heading 検索条件
            p.title {{current_params.query}}
        .level-item.has-text-centered
          div
            p.heading 順序
            p.title {{Dictionary.fetch(current_params.sort_column).name}}{{Dictionary.fetch(current_params.sort_order).name}}

      b-field(label="対象" custom-class="is-small" :message="current_scope_info.message")
        template(v-for="e in config.scope_info")
          b-radio-button(size="is-small" v-model="zip_dl_scope_key" :native-value="e.key" @input="input1_handle")
            | {{e.name}} ({{e.count}})

      b-field(label="フォーマット" custom-class="is-small")
        template(v-for="e in ZipDlInfo.values")
          b-radio-button(size="is-small" v-model="zip_dl_format_key" :native-value="e.key" @input="input2_handle")
            | {{e.name}}

      b-field(label="文字コード" custom-class="is-small")
        template(v-for="e in EncodeInfo.values")
          b-radio-button(size="is-small" v-model="encode_key" :native-value="e.key" @input="input3_handle")
            | {{e.name}}

      b-field.zip_dl_max(label="件数最大" custom-class="is-small" v-if="development_p")
        b-radio-button(size="is-small" v-model="zip_dl_max" :native-value="0" @input="sound_play('click')") 0
        b-radio-button(size="is-small" v-model="zip_dl_max" :native-value="1" @input="sound_play('click')") 1
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

import MemoryRecord from 'js-memory-record'

// class ScopeInfo extends MemoryRecord {
//   static get define() {
//     return [
//       { key: "latest",    name: "直近",           },
//       { key: "today",     name: "本日分",         },
//       { key: "continue",  name: "前回の続きから", },
//     ]
//   }
// }

class ZipDlInfo extends MemoryRecord {
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

class EncodeInfo extends MemoryRecord {
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
      encode_key: null,
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
    input1_handle(v) {
      this.sound_play('click')
      if (v === "zdsk_continue") {
        if (!this.g_current_user) {
          // this.talk_stop()
          // this.toast_ok("前回の続きからダウンロードするにはいったんログインして、そのあと初回だけ「前回の続きから」以外の方法でダウンロードしてください。そうすると使えるようになります")
        }
      }
    },
    input2_handle(v) {
      this.sound_play('click')
      if (v === "sfen") {
        this.talk_stop()
        this.toast_ok("よくわからない場合は KIF にしてください")
      }
    },
    input3_handle(v) {
      this.sound_play('click')
      if (v === "Shift_JIS") {
        this.talk_stop()
        this.toast_ok("ShogiGUI で連続棋譜解析する場合はこっち")
      }
    },

    download_handle() {
      if (this.current_scope_info.count === 0) {
        this.toast_warn("ダウンロードするデータがありません")
        return
      }

      this.sidebar_p = false
      this.sound_play("click")

      const params = {
        ...this.current_params,
        zip_dl_scope_key:  this.zip_dl_scope_key,
        zip_dl_format_key: this.zip_dl_format_key,
        zip_dl_max:        this.zip_dl_max,
        body_encode:       this.encode_key,
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

    async swars_zip_dl_logs_destroy_all() {
      await this.$axios.$get("/w.json", {params: {swars_zip_dl_logs_destroy_all: "true"}})
      this.$fetch()
    },

    async oldest_log_create_handle() {
      await this.$axios.$get("/w.json", {params: {...this.current_params, oldest_log_create: "true"}})
      this.$fetch()
    },

    back_handle() {
      this.sound_play('click')
      this.back_to({name: "swars-search", query: this.current_params})
    },
  },
  computed: {

    // ScopeInfo() { return ScopeInfo },
    ZipDlInfo() { return ZipDlInfo },
    EncodeInfo() { return EncodeInfo },
    Dictionary() { return Dictionary },

    current_params() { return this.$route.query },

    current_scope_info() { return this.config.scope_info[this.zip_dl_scope_key] },

    meta() {
      return {
        title: this.page_title,
        og_title: this.page_title,
        og_description: "",
      }
    },
    page_title() {
      // return `${this.current_params.query} - 棋譜ダウンロード`
      return `棋譜ダウンロード`
    },

    //////////////////////////////////////////////////////////////////////////////// for ls_support
    ls_storage_key() {
      return "swars_download_params"
    },
    ls_default() {
      return {
        ...this.config.form_params_default,
        // zip_dl_scope_key: "latest",
        // zip_dl_format_key: "kif",
        // encode_key: "UTF-8",
      }
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

    // .notification
    //   padding-right: 1.25rem // notification はクローズボタンを考慮して右のpaddingが広くなっているため左と同じにする

    // .block:not(:first-child)
    //   margin-top: 1.5rem;

    .field:not(:last-child)
      margin-bottom: 1.5rem

    .buttons
      // margin-top: 2.5rem
      +mobile
        justify-content: center

    .zip_dl_max
      max-width: 3rem

</style>
