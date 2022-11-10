<template lang="pug">
b-loading(active)
</template>

<script>
export default {
  async asyncData({$axios, params, query}) {
    // http://localhost:3000/w/DevUser1-YamadaTaro-20200101_123401.json?basic_fetch=1
    // http://localhost:4000/swars/battles/DevUser1-YamadaTaro-20200101_123401
    // http://localhost:4000/swars/battles/DevUser1-YamadaTaro-20200101_123401/piyo
    const record = await $axios.$get(`/w/${params.key}.json`, {params: {basic_fetch: true, ...query}})
    return { record }
  },
  mounted() {
    location.href = this.$KifuVo.create({
      kif_url: `${this.$config.MY_SITE_URL}${this.record.show_path}.kif`,
      sfen: this.record.sfen_body,
      turn: this.record.display_turn,
    }).piyo_url
  },
}
</script>
