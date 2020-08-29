<template lang="pug">
.section
  .columns
    .column
      div(v-for="(item, key) of items" :key="key")
        nuxt-link(:to="item.to" exact-active-class="is-active") {{item.title}}
      b-button(type="is-primary") BUTTON
</template>

<script>
export default {
  name: "index",
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
          to: { name: 'training' },
        },
        {
          title: '対局時計',
          to: { name: 'vs-clock' },
        },
      ]
    }
  }
}
</script>
