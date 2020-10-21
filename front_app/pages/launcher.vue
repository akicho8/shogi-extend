<template lang="pug">
.launcher
  MainNavbar
    template(slot="brand")
      NavbarItemHome
      b-navbar-item.has-text-weight-bold(tag="nuxt-link" :to="{name: 'launcher'}") Launcher
    template(slot="start" v-if="development_p")
      b-navbar-item(:href="$config.MY_SITE_URL") {{$config.MY_SITE_URL}}
    template(slot="end")
      NavbarItemLogin
      NavbarItemProfileLink
  MainSection
    .container
      .columns.is-marginless
        .column
          .card
            .card-content
              div(v-for="(item, key) of production_items" :key="key")
                nuxt-link(:to="item.to" exact-active-class="is-active") {{item.title}}
        .column
          .card
            .card-content
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
  name: "launcher",
  data () {
    return {
      CSR_ENV_BUILD_VERSION: process.env.ENV_BUILD_VERSION,
      production_items: [
        { title: "Home",                               to: { name: "index"                           }, },
        { title: "サウンドテスト",                     to: { name: "sound-test", }},
        { title: "プロフィール編集",                   to: { name: "settings-profile", }},
        { title: "ユーザー詳細",                       to: { name: "users-id", params: {id: 1}, }, },
        { title: "将棋ウォーズバトル詳細"    ,         to: { name: "swars-battles-key", params: {key: "devuser1-Yamada_Taro-20200101_123401"}, }, },
        { title: "将棋ウォーズプレイヤー情報2",        to: { name: "swars-users-key",   params: {key: "devuser1"}, }, },
        { title: "将棋ウォーズショートカット kento",      to: { name: 'swars-users-key-direct-open-external_app_key', params: { key: "devuser1", external_app_key: "kento",        }}},
        { title: "将棋ウォーズショートカット piyo_shogi", to: { name: 'swars-users-key-direct-open-external_app_key', params: { key: "devuser1", external_app_key: "piyo_shogi", }}},
        { title: "将棋ウォーズショート一括DL",         to: { name: 'swars-users-key-download-all', params: { key: "devuser1", }}},

        { title: "将棋ウォーズプレイヤー情報",         to: { name: "swars-users-key",   params: {key: "devuser1"}, }, },
        { title: "将棋ウォーズ棋譜検索",               to: { name: "swars-search",                   }, },
        { title: "将棋ウォーズイベント上位プレイヤー", to: { name: "swars-top-group",               }, },
        { title: "将棋ウォーズ指導対局成績",             to: { name: "swars-professional",             }, },
        { title: "将棋ウォーズ分布",                   to: { name: "swars-histograms-key", params: {key: "attack"}, }, },
        { title: "将棋ウォーズ段級分布",               to: { name: "swars-histograms-grade"           }, },
        { title: "将棋トレーニングバトル",             to: { name: "training"                        }, },
        { title: "三段リーグ成績早見表",               to: { name: "three-stage-leagues-generation"  }, },
        { title: "三段リーグ個人成績"  ,               to: { name: "three-stage-league-players-name" }, },
        { title: "なんでも棋譜変換",                   to: { name: "adapter"                         }, },
        { title: "共有将棋盤",                         to: { name: "share-board"                     }, },
        { title: "CPU対戦",                            to: { name: "cpu-battle"                      }, },
        { title: "利用規約",                           to: { name: "about-terms"                     }, },
        { title: "プライバシー  ",                     to: { name: "about-privacy-policy"            }, },
        { title: "クレジット",                         to: { name: "about-credit"                    }, },
        { title: "対局時計",                           to: { name: "vs-clock"                        }, },
        { title: "ストップウォッチ",                   to: { name: "stopwatch"                       }, },
        { title: "符号の鬼",                           to: { name: "xy"                              }, },
      ],
      experiment_items: [
        { title: "store 動作検証",             to: { name: "experiment-store_test"        }, },
        { title: "fetch 動作検証",             to: { name: "experiment-fetch_test"        }, },
        { title: "users/_id 動作検証",         to: { name: "experiment-users-id"          }, },
        { title: "DOCTOR",                     to: { name: "experiment-doctor"            }, },
        { title: "フルスクリーンAPIテスト",    to: { name: "experiment-full_screen_api"   }, },
        { title: "フルスクリーンモデルテスト", to: { name: "experiment-full_screen_model" }, },
        { title: "初期非同期外部IP確認",       to: { name: "experiment-ip-show"           }, },
        { title: "初期非同期読み込み",         to: { name: "experiment-async_data_test"   }, },
        { title: "Bulma動作チェック",          to: { name: "experiment-bulma_test"        }, },
        { title: "オンラインチェック",         to: { name: "experiment-online_offline"    }, },
        { title: "YES/NO API",                 to: { name: "experiment-yesno_test"        }, },
        { title: "Inspire",                    to: { name: "inspire"                      }, },
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
