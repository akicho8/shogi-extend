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
      template(v-if="!g_current_user")
        b-notification(type="is-warning")
          | この機能を使う場合はいったんログインしてください

      b-field(label="範囲" custom-class="is-small")
        template(v-for="e in config.scope_info")
          b-radio-button(v-model="zip_scope_key" :native-value="e.key" @input="sound_play('click')")
            | {{e.name}} ({{e.count}})

      b-field(label="書式" custom-class="is-small")
        template(v-for="e in ZipDlInfo.values")
          b-radio-button(v-model="zip_format_key" :native-value="e.key" @input="sound_play('click')")
            | {{e.name}}

      b-field(label="文字コード" custom-class="is-small")
        template(v-for="e in EncodeInfo.values")
          b-radio-button(v-model="encode_key" :native-value="e.key" @input="sound_play('click')")
            | {{e.name}}

      template(v-if="development_p")
        b-field.zip_dl_max(label="最大件数" custom-class="is-small")
          b-radio-button(v-model="zip_dl_max" :native-value="0" @input="sound_play('click')") 0
          b-radio-button(v-model="zip_dl_max" :native-value="1" @input="sound_play('click')") 1
          b-radio-button(v-model="zip_dl_max" :native-value="50" @input="sound_play('click')") 50

      .buttons.mt-5
        b-button(@click="download_handle") ダウンロード
        b-button(@click="swars_zip_dl_logs_destroy_all" v-if="development_p") クリア

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
    if (this.g_current_user) {
      const params = {
        query: this.target_user_key,
        download_config_fetch: "true",
      }
      return this.$axios.$get("/w.json", {params: params}).then(e => {
        this.config = e
        this.ls_setup()
      })
    }
  },
  methods: {
    download_handle() {
      if (!this.g_current_user) {
        this.toast_warn("ログインしてください")
        return
      }

      this.sidebar_p = false
      this.sound_play("click")

      // this.toast_ok(`${e.encode_key} の ${e.zip_format_key_upcase} をダウンロードしています`)

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

      // this.delay_block(3, () => {
      //   this.toast_ok(`たぶんダウンロード完了しました`, {
      //     onend: () => {
      //       this.toast_ok(`もっとたくさんダウンロードしたいときは「古い棋譜を取得」のほうを使ってください`)
      //     },
      //   })
      // })

      // const params = {
      //   crawl_reservation: {
      //     target_user_key: this.$route.params.key,
      //     config:        this.config,
      //     attachment_mode: this.attachment_mode,
      //   },
      // }
      // this.loading_p = true
      // const retv = await this.$axios.$post("/api/swars/download_set", params)
      // this.loading_p = false
      // this.notice_collector_run(retv)
    },

    swars_zip_dl_logs_destroy_all() {
      this.$axios.$get("/w.json", {params: {swars_zip_dl_logs_destroy_all: "true"}})
    },

    async crawler_run_handle_handle() {
      const retv = await this.$axios.$post("/api/swars/crawler_run")
      this.notice_collector_run(retv)
    },

    back_handle() {
      this.sound_play('click')
      this.back_to({name: "swars-search", query: {query: this.$route.params.key}})
    },
  },
  computed: {
    ScopeInfo() { return ScopeInfo },
    ZipDlInfo() { return ZipDlInfo },
    EncodeInfo() { return EncodeInfo },

    target_user_key() { return this.$route.params.key },

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
    .container
      max-width: 65ch
    .notification
      padding-right: 1.25rem // notification はクローズボタンを考慮して右のpaddingが広くなっているため左と同じにする

    // .block:not(:first-child)
    //   margin-top: 1.5rem;

    .field:not(:last-child)
      margin-bottom: 1rem

    .zip_dl_max
      max-width: 3rem

</style>
