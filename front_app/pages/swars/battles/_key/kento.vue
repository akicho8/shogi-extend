<template lang="pug">
b-loading(active)
</template>

<script>
export default {
  async asyncData({$axios, params, query}) {
    // http://0.0.0.0:3000/w/devuser1-Yamada_Taro-20200101_123401.json?basic_fetch=1
    // http://0.0.0.0:4000/swars/battles/devuser1-Yamada_Taro-20200101_123401
    // http://0.0.0.0:4000/swars/battles/devuser1-Yamada_Taro-20200101_123401/kento
    const record = await $axios.$get(`/w/${params.key}.json`, {params: {basic_fetch: true, ...query}})
    return { record }
  },
  mounted() {
    location.href = this.kento_full_url({sfen: this.record.sfen_body, turn: this.record.display_turn})
  },
}
</script>
