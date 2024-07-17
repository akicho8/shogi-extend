<template lang="pug">
QuickScriptView
</template>

<script>
export default {
  // リダイレクトする場合
  // async asyncData(c) {
  //   return c.redirect(303, {path: "/lab/chore/group", query: c.query})
  // },

  // 置き換える場合
  created() {
    this.$route.params.qs_group_key = "chore"
    this.$route.params.qs_page_key  = "group"
    // this.$route.query.qs_group_index = true
  },
}
</script>
