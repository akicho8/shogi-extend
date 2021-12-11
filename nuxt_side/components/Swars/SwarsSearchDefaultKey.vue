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
          | ウォーズIDを覚えると検索覧に毎回入力しなくてよくなります。主にぴよ将棋から来ている方におすすめです。

        template(v-if="present_p(old_key) && present_p(new_key) && old_key != new_key")
          .has-text-centered
            | {{old_key}} を消して {{new_key}} を覚えますか？
          .buttons.is-centered.mt-3
            b-button.set_handle(@click="set_handle") 覚える

        template(v-if="blank_p(old_key) && present_p(new_key)")
          .has-text-centered
            | {{new_key}} を覚えますか？
          .buttons.is-centered.mt-3
            b-button.set_handle(@click="set_handle") 覚える

        template(v-if="old_key")
          .has-text-centered
            | いま覚えている {{old_key}} を忘れますか？
          .buttons.is-centered.mt-3
            b-button.unset_handle(@click="unset_handle") 忘れる
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
      this.sound_play_click()
      MyLocalStorage.set("swars_search_default_key", this.new_key)
      this.old_key = MyLocalStorage.get("swars_search_default_key")
      this.toast_ok("覚えました")
      this.$router.push({name: "swars-search"})
    },
    unset_handle() {
      this.sound_play_click()
      MyLocalStorage.remove("swars_search_default_key")
      this.old_key = MyLocalStorage.get("swars_search_default_key")
      this.toast_ok("忘れました")
      this.$router.push({name: "swars-search"})
    },
    back_handle() {
      this.sound_play_click()
      this.back_to({name: "swars-search", query: {query: this.$route.params.key}})
    },
  },
  computed: {
    page_title() { return "ウォーズIDを覚える"     },
    new_key()    { return this.$route.params.key },
    meta() {
      return {
        title: this.page_title,
        twitter_card_is_small: true,
        og_image_key: "swars-search",
        og_description: "",
      }
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
