<template lang="pug">
FormalSheetShow(:info="info")
</template>

<script>
export default {
  async asyncData({$axios, params, query}) {
    // http://localhost:3000/w/devuser1-Yamada_Taro-20200101_123401.json?formal_sheet=1
    // http://localhost:4000/swars/battles/devuser1-Yamada_Taro-20200101_123401/formal-sheet
    const info = await $axios.$get("/api/adapter/formal_sheet.json", {params: {...query, key: params.key}})
    return { info }
  },
}
</script>

<style lang="sass">
</style>
