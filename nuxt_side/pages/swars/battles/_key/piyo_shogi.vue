<template lang="pug">
b-loading(active)
</template>

<script>
export default {
  async asyncData({$axios, params, query}) {
    // http://localhost:3000/w/devuser1-Yamada_Taro-20200101_123401.json?basic_fetch=1
    // http://localhost:4000/swars/battles/devuser1-Yamada_Taro-20200101_123401
    // http://localhost:4000/swars/battles/devuser1-Yamada_Taro-20200101_123401/piyo
    const record = await $axios.$get(`/w/${params.key}.json`, {params: {basic_fetch: true, ...query}})
    return { record }
  },
  mounted() {
    location.href = this.piyo_shogi_auto_url({
      path: `/w/${this.record.key}`,
      sfen: this.record.sfen_body,
      turn: this.record.display_turn,
      ...this.record.piyo_shogi_base_params,
    })
  },
}
</script>
