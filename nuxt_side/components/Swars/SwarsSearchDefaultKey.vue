<template lang="pug">
client-only
  .SwarsSearchDefaultKey
    MainNavbar
      template(slot="brand")
        b-navbar-item(@click="back_handle")
          b-icon(icon="chevron-left")
        b-navbar-item.has-text-weight-bold.is-size-7-mobile(tag="div") {{page_title}}
    MainSection
      .container
        b-notification(:closable="false")
          | 検索初期値を設定すると最初の画面が検索結果になるので、毎回<b>ぴよ将棋</b>から来ている方におすすめです

        template(v-if="!old_key || (old_key != new_key)")
          .has-text-centered
            p {{new_key}}さんを初期値に設定しますか？
          .buttons.is-centered.mt-3
            b-button(@click="set_handle") 設定する

        template(v-if="old_key")
          .has-text-centered
            p 初期値({{old_key}}さん)を消去しますか？
          .buttons.is-centered.mt-3
            b-button(@click="unset_handle") 消去する
</template>

<script>
import { MyLocalStorage } from "@/components/models/my_local_storage.js"

export default {
  name: "SwarsSearchDefaultKey",
  data() {
    return {
      old_key: null,
    }
  },
  mounted() {
    this.old_key = MyLocalStorage.get("swars_search_default_key")
  },
  methods: {
    set_handle() {
      this.sound_play('click')
      MyLocalStorage.set("swars_search_default_key", this.new_key)
      this.old_key = MyLocalStorage.get("swars_search_default_key")
      this.toast_ok("設定しました")
    },
    unset_handle() {
      this.sound_play('click')
      MyLocalStorage.remove("swars_search_default_key")
      this.old_key = MyLocalStorage.get("swars_search_default_key")
      this.toast_ok("消去しました")
    },
    back_handle() {
      this.sound_play('click')
      this.back_to({name: "swars-search", query: {query: this.$route.params.key}})
    },
  },
  computed: {
    meta() {
      return {
        title: this.page_title,
        twitter_card_is_small: true,
        og_image_key: "swars-search",
        og_description: "",
      }
    },
    page_title() {
      return "検索初期値の設定"
    },
    new_key() {
      return this.$route.params.key
    },
  },
}
</script>

<style lang="sass">
.SwarsSearchDefaultKey
  .MainSection.section
    .container
      max-width: 40rem
    .notification
      padding-right: 1.25rem // notification はクローズボタンを考慮して右のpaddingが広くなっているため左と同じにする
</style>
