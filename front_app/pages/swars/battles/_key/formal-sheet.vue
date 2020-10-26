<template lang="pug">
FormalSheetShow(:info="info")
</template>

<script>
export default {
  name: "swars-battles-key-formal-sheet",
  async asyncData({$axios, params, query}) {
    // http://0.0.0.0:3000/w/devuser1-Yamada_Taro-20200101_123401.json?formal_sheet=1
    // http://0.0.0.0:4000/swars/battles/devuser1-Yamada_Taro-20200101_123401/formal-sheet
    const info = await $axios.$get(`/w/${params.key}.json`, {params: {formal_sheet: true, ...query}})
    return { info }
  },
}
</script>

<style lang="sass">
</style>
