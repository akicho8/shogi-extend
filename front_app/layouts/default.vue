<template lang="pug">
div
  nuxt
  hr
  div(v-for="(item, key) of items" :key="key")
    nuxt-link(:to="item.to" exact-active-class="is-active") {{item.title}}
</template>

<script>
export default {
  data () {
    return {
      items: [
        {
          title: 'Home',
          icon: 'home',
          to: { name: 'index' }
        },
        {
          title: 'Inspire',
          icon: 'lightbulb',
          to: { name: 'inspire' }
        },
        {
          title: 'privacy_policy',
          to: { name: 'about-privacy_policy' },
        },
        {
          title: '将棋トレーニングバトル',
          to: { name: 'tb' },
        },
      ]
    }
  }
}
</script>
