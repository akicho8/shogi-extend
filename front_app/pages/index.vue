<template lang="pug">
.section
  .columns.is-marginless
    .column
      Logo
      .box
        div(v-for="(item, key) of items" :key="key")
          nuxt-link(:to="item.to" exact-active-class="is-active") {{item.title}}
</template>

<script>
export default {
  name: "index",
  data () {
    return {
      items: [
        { title: 'Home',                     to: { name: 'index'                }, },
        { title: 'Inspire',                  to: { name: 'inspire'              }, },
        { title: 'privacy-policy',           to: { name: 'about-privacy-policy' }, },
        { title: 'terms',                    to: { name: 'about-terms' }, },
        { title: '対局時計',                 to: { name: 'vs-clock'             }, },
        { title: 'IP',                       to: { name: 'ip-show'              }, },
        { title: 'async_data_test',          to: { name: 'async_data_test'      }, },
        { title: 'bulma_test',               to: { name: 'bulma_test'           }, },
        { title: '$nuxt.isOffline チェック', to: { name: 'online_offline'       }, },
      ]
    }
  }
}
</script>
