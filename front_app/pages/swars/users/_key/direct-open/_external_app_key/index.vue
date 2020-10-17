<template lang="pug">
client-only
  .swars-users-key-direct-open-external_app_key
    MainNavbar
      template(slot="brand")
        b-navbar-item.has-text-weight-bold(tag="div") {{long_title}}
    MainSection
      .container
        b-button(tag="nuxt-link" :to="{name: 'swars-search', query: {query: $route.params.key}}" @click.native="sound_play('click')")
          | ← 検索に戻る
        pre(v-if="development_p") {{config}}
</template>

<script>
import { MyLocalStorage } from "@/components/models/MyLocalStorage.js"
import { ExternalAppInfo } from "@/components/models/ExternalAppInfo.js"

export default {
  name: "swars-users-key-direct-open-external_app_key",
  data() {
    return {
      external_app_setup: null,
      config: null,
    }
  },
  head() {
    return {
      title: this.external_app_info.shortcut_name, // アイコン名なので短かく
      titleTemplate: null,
      meta: [
        { hid: "og:title",       property: "og:title",       content: this.long_title,                                    },
        { hid: "twitter:card",   property: "twitter:card",   content: "summary",                                          },
        { hid: "og:image",       property: "og:image",       content: this.$config.MY_OGP_URL + "/ogp/swars-search.png", },
        { hid: "og:description", property: "og:description", content: "",                                                 },
      ],
      link: [
        { hid: "apple-touch-icon", rel: "apple-touch-icon", href: `/apple-touch-icon/${this.external_app_info.key}.png` },
      ],
    }
  },
  fetchOnServer: false,
  fetch() {
    this.external_app_setup = MyLocalStorage.get("external_app_setup")
    MyLocalStorage.remove("external_app_setup")

    if (this.external_app_setup) {
      this.$buefy.dialog.alert({
        title: "設定",
        message: `
          <div class="content">
            <p>直前の対局を${this.external_app_info.name}で必ず検討する人向けのショートカットの設定です</p>
            <p>現在の画面を<b>ホーム画面に追加</b> (PCの場合はブークマークに追加) すると、そこから直前の対局を最短で開けるようになります</p>
            <p>具体的には検索して一番上に表示された対局の外部アプリをタップする流れを自動化する感じです</p>
          </div>`,
        confirmText: "OK",
        type: 'is-info',
        animation: "", // 最初から表示しているようにしたいのでアニメーションOFF
        onConfirm: () => this.sound_play("click"),
      })
    } else {
      return this.$axios.$get("/w.json", {params: {query: this.$route.params.key, per: 1}}).then(config => {
        this.config = config
        // this.config.records = []

        if (!this.record) {
          this.toast_ng("棋譜が見つかりませんでした")
          return
        }

        if (this.external_app_info.key === "piyo_shogi") {
          location.href = this.piyo_shogi_app_with_params_url
        }
        if (this.external_app_info.key === "kento") {
          location.href = this.kento_app_with_params_url
        }

      })
    }
  },

  computed: {
    external_app_key() {
      return this.$route.params.external_app_key
    },
    external_app_info() {
      return ExternalAppInfo.fetch(this.external_app_key)
    },
    long_title() {
      return `${this.$route.params.key}さんの直近対局を${this.external_app_info.name}ですぐ開く画面`
    },
    record() {
      return this.config.records[0]
    },
    piyo_shogi_app_with_params_url() {
      if (this.record) {
        return this.piyo_shogi_auto_url({
          path: this.record.show_path,
          sfen: this.record.sfen_body,
          turn: this.record.display_turn,
          flip: this.record.flip,
          ...this.record.piyo_shogi_base_params,
        })
      }
    },
    kento_app_with_params_url() {
      if (this.record) {
        return this.kento_full_url({
          sfen: this.record.sfen_body,
          turn: this.record.display_turn,
          flip: false,
        })
      }
    },
  },
}
</script>

<style lang="sass">
.swars-users-key-direct-open-external_app_key
  .MainSection
    &:first-of-type
      padding-top: 1.8rem
</style>
