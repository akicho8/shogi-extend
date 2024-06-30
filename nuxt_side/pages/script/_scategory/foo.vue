<template lang="pug">
QuickScriptShow
</template>

<script>
export default {
  async asyncData(c) {
    return c.redirect(303, {path: "/script/chore/index", query: c.query})
  },
}
</script>
