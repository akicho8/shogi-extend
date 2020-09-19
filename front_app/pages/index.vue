<template lang="pug">
div
  b-navbar(type="is-primary")
    template(slot="brand")
      b-navbar-item(tag="a" :href="$config.MY_SITE_URL")
        span.ml-2
          b SHOGI-EXTEND
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
    .columns
      .column
        .box
          pre
            | CSR_BUILD_VERSION: {{$config.CSR_BUILD_VERSION}}
            | SSR_BUILD_VERSION: {{SSR_config.SSR_BUILD_VERSION}}
            |
            | CSR_ENV_BUILD_VERSION: {{CSR_ENV_BUILD_VERSION}}
            | SSR_ENV_BUILD_VERSION: {{SSR_ENV_BUILD_VERSION}}
</template>

<script>
export default {
  name: "index",
  data () {
    return {
      CSR_ENV_BUILD_VERSION: process.env.ENV_BUILD_VERSION,
      production_items: [
        { title: 'Home',                     to: { name: 'index'                      }, },
        { title: 'なんでも棋譜変換',         to: { name: 'adapter'                    }, },
        { title: '共有将棋盤',               to: { name: 'share-board'                }, },
        { title: 'CPU対戦',                  to: { name: 'cpu-battle'                 }, },
        { title: '利用規約',                 to: { name: 'about-terms'                }, },
        { title: 'プライバシー  ',           to: { name: 'about-privacy-policy'       }, },
        { title: 'クレジット',               to: { name: 'about-credit'               }, },
        { title: '対局時計',                 to: { name: 'vs-clock'                   }, },
        { title: 'ストップウォッチ',         to: { name: 'stopwatch'                  }, },
        { title: '符号の鬼',                 to: { name: 'xy'                         }, },
      ],
      experiment_items: [
        { title: 'DOCTOR',                     to: { name: 'experiment-doctor'            }, },
        { title: 'フルスクリーンAPIテスト',    to: { name: 'experiment-full_screen_api'   }, },
        { title: 'フルスクリーンモデルテスト', to: { name: 'experiment-full_screen_model' }, },
        { title: '初期非同期外部IP確認',       to: { name: 'experiment-ip-show'           }, },
        { title: '初期非同期読み込み',         to: { name: 'experiment-async_data_test'   }, },
        { title: 'Bulma動作チェック',          to: { name: 'experiment-bulma_test'        }, },
        { title: 'オンラインチェック',         to: { name: 'experiment-online_offline'    }, },
        { title: 'YES/NO API',                 to: { name: 'experiment-yesno_test'        }, },
        { title: 'Inspire',                    to: { name: 'inspire'                      }, },
      ],
    }
  },
  async asyncData({$config}) {
    return {
      SSR_config: $config,
      SSR_ENV_BUILD_VERSION: process.env.ENV_BUILD_VERSION,
    }
  },
}
</script>
