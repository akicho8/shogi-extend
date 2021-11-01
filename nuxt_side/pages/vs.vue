<template lang="pug">
.page-vs
  template(v-if="false")
    template(v-for="e in XmatchRuleInfo.values")
      h2 {{e.name}}
      h3 {{e.rule_desc}}
  b-loading(active)
</template>

<script>
// import { XmatchRuleInfo } from "@/components/models/xmatch_rule_info.js"

export default {
  name: "page-vs",
  beforeMount() {
    // マウント前に実行してもマウント前に遷移するわけじゃない
    // Googlebot用にHTMLを入れておいたが遷移中に表示されてしまうのでテンプレートは空にしとこう
    this.$router.replace({name: "share-board", query: {...this.$route.query, autoexec: "vs"}})
  },
  computed: {
    meta() {
      return {
        title: "対人戦",
        description: "1〜8人で対戦できる",
        og_image_key: "share-board-vs",
      }
    },
    XmatchRuleInfo() { return XmatchRuleInfo },
  },
}
</script>

<style lang="sass">
.page-vs
</style>
