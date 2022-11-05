<template lang="pug">
FormalSheetShow(:info="info")
</template>

<script>
export default {
  async asyncData({$axios, params, query}) {
    // http://localhost:3000/w/DevUser1-YamadaTaro-20200101_123401.json?formal_sheet=1
    // http://localhost:4000/swars/battles/DevUser1-YamadaTaro-20200101_123401/formal-sheet
    const info = await $axios.$get("/api/adapter/formal_sheet.json", {params: {...query, key: params.key}})
    return { info }
  },
}
</script>

<style lang="sass">
</style>
