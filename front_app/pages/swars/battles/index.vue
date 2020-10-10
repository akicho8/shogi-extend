<template lang="pug">
client-only
  SwarsBattleIndex
</template>

<script>
import _ from "lodash"

export default {
  name: "swars-battles",
  head() {
    return {
      title: this.page_title,
      meta: [
        { hid: "og:title",       property: "og:title",       content: this.page_title,                                                                                      },
        { hid: "og:image",       property: "og:image",       content: this.$config.MY_OGP_URL + "/ogp/swars-battles.png"                                                    },
        { hid: "og:description", property: "og:description", content: "ウォーズの棋譜をぴよ将棋やKENTOで開いたりクリップボード経由で外部アプリに渡すような使い方ができます" },
      ],
    }
  },
  computed: {
    page_title() {
      return _.compact([this.$route.query.query, "将棋ウォーズ棋譜検索"]).join(" - ")
    },
  },
}
</script>

<style lang="sass">
</style>
