<template lang="pug">
div
  b-navbar(type="is-primary")
    template(slot="brand")
      b-navbar-item(tag="a" :href="$config.BASE_URL")
        Logo
        span.ml-2
          b SHOGI-EXTEND
    template(slot="start")
  .section.pt-5
    .columns.is-marginless
      .column
        .box
          div(v-for="(item, key) of production_items" :key="key")
            nuxt-link(:to="item.to" exact-active-class="is-active") {{item.title}}
      .column
        .box
          div(v-for="(item, key) of experiment_items" :key="key")
            nuxt-link(:to="item.to" exact-active-class="is-active") {{item.title}}
</template>

<script>
export default {
  name: "index",
  data () {
    return {
      production_items: [
        { title: 'Home',                     to: { name: 'index'                      }, },
        { title: '利用規約',                 to: { name: 'about-terms'                }, },
        { title: 'プライバシー  ',           to: { name: 'about-privacy-policy'       }, },
        { title: 'クレジット',               to: { name: 'about-credit'               }, },
        { title: '対局時計',                 to: { name: 'vs-clock'                   }, },
        { title: 'ストップウォッチ',         to: { name: 'stopwatch'                  }, },
      ],
      experiment_items: [
        { title: 'フルスクリーン',           to: { name: 'experiment-full_screen'     }, },
        { title: 'Inspire',                  to: { name: 'experiment-inspire'         }, },
        { title: 'IP',                       to: { name: 'experiment-ip-show'         }, },
        { title: 'async_data_test',          to: { name: 'experiment-async_data_test' }, },
        { title: 'bulma_test',               to: { name: 'experiment-bulma_test'      }, },
        { title: '$nuxt.isOffline チェック', to: { name: 'experiment-online_offline'  }, },
      ],
    }
  }
}
</script>
