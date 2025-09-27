<template lang="pug">
client-only
  .swars-users-key-direct-open-external_app_key
    MainNavbar
      template(slot="brand")
        b-navbar-item.has-text-weight-bold.is-size-7-mobile(tag="div") {{long_title}}
    MainSection
      .container
        b-button(tag="nuxt-link" :to="{name: 'swars-search', query: {query: $route.params.key}}" @click.native="sfx_play_click()")
          | ← 検索に戻る
    DebugPre(v-if="development_p") {{config}}
</template>

<script>
import { MyLocalStorage } from "@/components/models/my_local_storage.js"
import { ExternalAppInfo } from "@/components/models/external_app_info.js"

export default {
  name: "swars-users-key-direct-open-external_app_key",
  data() {
    return {
      external_app_setup: null,
      config: null,
    }
  },
  fetchOnServer: false,
  fetch() {
    this.external_app_setup = MyLocalStorage.get("external_app_setup")
    MyLocalStorage.remove("external_app_setup")

    if (this.external_app_setup) {
      this.$buefy.dialog.alert({
        title: "これは何？",
        message: `
          <div class="content">
            <p>この画面のURLは直近の対局を<b>${this.external_app_info.name}</b>で開くショートカットになっています。</p>
            <p>したがって、この状態で<b>ホーム画面に追加</b>、またはブックマークしておくと直近を最短で開けるようになります。</p>
            <p>検索して一番上の対局の${this.external_app_info.name}ボタンをタップする流れを自動化するイメージです。</p>
          </div>`,
        confirmText: "わかった",
        type: 'is-info',
        animation: "", // 最初から表示しているようにしたいのでアニメーションOFF
        onConfirm: () => this.sfx_play_click(),
      })
    } else {
      return this.$axios.$get("/w.json", {params: {query: this.$route.params.key, per: 1}}).then(config => {
        this.config = config
        if (!this.record) {
          this.toast_warn("棋譜が見つかりませんでした")
          return
        }
        if (this.external_app_info.key === "piyo_shogi") {
          location.href = this.current_kifu_vo.piyo_url
        }
        if (this.external_app_info.key === "kento") {
          location.href = this.current_kifu_vo.kento_url
        }
      })
    }
  },

  computed: {
    meta() {
      return {
        page_title_only: true,
        title: this.external_app_info.shortcut_name, // アイコン名なので短かく
        og_title: this.long_title,
        og_card_size: "small",
        og_image_key: "swars-search",
        og_description: "",
        link: [
          { hid: "apple-touch-icon", rel: "apple-touch-icon", href: `/apple-touch-icon/${this.external_app_info.key}.png` },
        ],
      }
    },
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
    current_kifu_vo() {
      if (this.record) {
        return this.$KifuVo.create({
          kif_url: `${this.$config.MY_SITE_URL}${this.record.show_path}.kif`,
          sfen: this.record.sfen_body,
          turn: this.record.display_turn,
          viewpoint: this.record.viewpoint,
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
