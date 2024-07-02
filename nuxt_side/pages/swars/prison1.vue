<template lang="pug">
QuickScriptShow
</template>

<script>
export default {
  created() {
    this.$route.params.qs_group = "swars"
    this.$route.params.qs_key   = "prison"
  },
}
</script>
