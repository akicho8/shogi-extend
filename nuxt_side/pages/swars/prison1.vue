<template lang="pug">
QuickScriptShow
</template>

<script>
export default {
  created() {
    this.$route.params.sgroup = "swars"
    this.$route.params.skey   = "prison"
  },
}
</script>
