<template lang="pug">
.buttons
  template(v-for="item in items")
    b-button(tag="nuxt-link" :to="item.to" exact-active-class="is-active") {{item.title}}
</template>

<script>
export default {
  name: "HistogramNaviButtons",
  data() {
    return {
      items: [
        { title: '戦型', to: { name: 'swars-histograms-key', params: {key: 'attack'    }, }, },
        { title: '囲い', to: { name: 'swars-histograms-key', params: {key: 'defense'   }, }, },
        { title: '手筋', to: { name: 'swars-histograms-key', params: {key: 'technique' }, }, },
        { title: '備考', to: { name: 'swars-histograms-key', params: {key: 'note'      }, }, },
        { title: '段級', to: { name: 'swars-grade-histogram'                              }, },
      ],
    }
  },
}
</script>
