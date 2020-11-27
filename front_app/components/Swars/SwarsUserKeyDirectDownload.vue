<template lang="pug">
.SwarsUserKeyDirectDownload
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

      b-field(label="範囲" custom-class="is-small")
        template(v-for="e in config.scope_info")
          b-radio-button(size="is-small" v-model="zip_scope_key" :native-value="e.key" @input="input1_handle")
            | {{e.name}} ({{e.count}})

      b-field(label="フォーマット" custom-class="is-small")
        template(v-for="e in ZipDlInfo.values")
          b-radio-button(size="is-small" v-model="zip_format_key" :native-value="e.key" @input="input2_handle")
            | {{e.name}}

      b-field(label="文字コード" custom-class="is-small")
        template(v-for="e in EncodeInfo.values")
          b-radio-button(size="is-small" v-model="encode_key" :native-value="e.key" @input="input3_handle")
            | {{e.name}}

      b-field.zip_dl_max(label="件数最大" custom-class="is-small" v-if="development_p")
        b-radio-button(size="is-small" v-model="zip_dl_max" :native-value="0" @input="sound_play('click')") 0
        b-radio-button(size="is-small" v-model="zip_dl_max" :native-value="1" @input="sound_play('click')") 1
        b-radio-button(size="is-small" v-model="zip_dl_max" :native-value="50" @input="sound_play('click')") 50

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

import MemoryRecord from 'js-memory-record'

class ScopeInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "latest",    name: "直近",           },
      { key: "today",     name: "本日分",         },
      { key: "continue",  name: "前回の続きから", },
    ]
  }
}

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
  name: "SwarsUserKeyDirectDownload",
  mixins: [ls_support],
  data() {
    return {
      // for ls_support
      zip_scope_key:  null,
      zip_format_key: null,
      encode_key: null,
      zip_dl_max: null,

      config: null,
      loading_p: false,
    }
  },
  fetchOnServer: false,
  fetch() {
    const params = {
      query: this.target_user_key,
      download_config_fetch: "true",
    }
    return this.$axios.$get("/w.json", {params: params}).then(e => {
      this.config = e
      this.ls_setup()
    })
  },
  methods: {
    input1_handle(v) {
      this.sound_play('click')
      if (v === "continue") {
        if (!this.g_current_user) {
          this.talk_stop()
          this.toast_ok("前回の続きからダウンロードするにはいったんログインして、そのあと初回だけ「前回の続きから」以外の方法でダウンロードしてください。そうすると使えるようになります")
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
        this.toast_ok("ShogiGUI で連続棋譜解析する場合はそれ")
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
        query:           this.target_user_key,
        zip_scope_key:   this.zip_scope_key,
        zip_format_key:  this.zip_format_key,
        body_encode:     this.encode_key,
        zip_dl_max:      this.zip_dl_max,
      }

      const usp = new URLSearchParams()
      _.each(params, (v, k) => usp.set(k, v))
      const url = this.$config.MY_SITE_URL + `/w.zip?${usp}`
      location.href = url

      this.loading_p = true
      this.delay_block(3, () => {
        this.loading_p = false
        this.$fetch()

        this.toast_ok(`たぶんダウンロード完了しました`, {
          onend: () => {
            this.toast_ok(`もっとたくさん取得したいときは「古い棋譜を夜中に取得」のほうを使ってください`)
          },
        })
      })
    },

    async swars_zip_dl_logs_destroy_all() {
      await this.$axios.$get("/w.json", {params: {swars_zip_dl_logs_destroy_all: "true"}})
      this.$fetch()
    },

    async oldest_log_create_handle() {
      await this.$axios.$get("/w.json", {params: {query: this.target_user_key, oldest_log_create: "true"}})
      this.$fetch()
    },

    back_handle() {
      this.sound_play('click')
      this.back_to({name: "swars-search", query: {query: this.target_user_key}})
    },
  },
  computed: {
    ScopeInfo() { return ScopeInfo },
    ZipDlInfo() { return ZipDlInfo },
    EncodeInfo() { return EncodeInfo },

    target_user_key() { return this.$route.params.key },

    current_scope_info() { return this.config.scope_info[this.zip_scope_key] },

    meta() {
      return {
        title: this.page_title,
        og_title: this.page_title,
        og_description: "",
      }
    },
    page_title() {
      return `${this.target_user_key}さんの棋譜をダウンロード`
    },

    //////////////////////////////////////////////////////////////////////////////// for ls_support
    ls_storage_key() {
      return "swars_download_params"
    },
    ls_default() {
      return {
        ...this.config.form_params_default,
        // zip_scope_key: "latest",
        // zip_format_key: "kif",
        // encode_key: "UTF-8",
      }
    },
  },
}
</script>

<style lang="sass">
.SwarsUserKeyDirectDownload
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
      margin-top: 2.5rem

    .zip_dl_max
      max-width: 3rem

</style>
