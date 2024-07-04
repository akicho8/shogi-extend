<template lang="pug">
QuickScriptShow
</template>

<script>
export default {
  created() {
    this.$route.params.qs_group_key = "swars"
    this.$route.params.qs_page_key   = "prison"
  },
}
</script>
