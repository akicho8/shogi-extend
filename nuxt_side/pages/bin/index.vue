<template lang="pug">
QuickScriptShow
</template>

<script>
export default {
  // リダイレクトする場合
  // async asyncData(c) {
  //   return c.redirect(303, {path: "/bin/chore/group_list", query: c.query})
  // },

  // 置き換える場合
  created() {
    this.$route.params.qs_group = "chore"
    this.$route.params.qs_key   = "group_list"
    // this.$route.query.sgroup_index = true
  },
}
</script>
