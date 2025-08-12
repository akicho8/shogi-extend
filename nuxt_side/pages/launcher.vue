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
          div(v-for="(item, key) of page_items" :key="key")
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
      page_items: [
        { title: "Home",                                  to: { name: "index"                           }, },
        { title: "サウンドテスト",                        to: { name: "sound-test", }},
        { title: "ユーザー詳細",                          to: { name: "users-id", params: {id: 1}, }, },
        { title: "将棋ウォーズバトル詳細"    ,            to: { name: "swars-battles-key", params: {key: "DevUser1-YamadaTaro-20200101_123401"}, }, },
        { title: "将棋ウォーズプレイヤー情報2",           to: { name: "swars-users-key",   params: {key: "DevUser1"}, }, },
        { title: "将棋ウォーズショートカット kento",      to: { name: 'swars-users-key-direct-open-external_app_key', params: { key: "DevUser1", external_app_key: "kento",        }}},
        { title: "将棋ウォーズショートカット piyo_shogi", to: { name: 'swars-users-key-direct-open-external_app_key', params: { key: "DevUser1", external_app_key: "piyo_shogi", }}},
        { title: "将棋ウォーズショート一括DL",            to: { name: 'swars-users-key-download-all', params: { key: "DevUser1", }}},
        { title: "将棋ウォーズプレイヤー情報",            to: { name: "swars-users-key",   params: {key: "DevUser1"}, }, },
        { title: "将棋ウォーズ棋譜検索",                  to: { name: "swars-search",                   }, },
        { title: "なんでも棋譜変換",                      to: { name: "adapter"                         }, },
        { title: "共有将棋盤",                            to: { name: "share-board"                     }, },
        { title: "CPU対戦",                               to: { name: "cpu-battle"                      }, },
        { title: "利用規約",                              to: { name: "about-terms"                     }, },
        { title: "プライバシー  ",                        to: { name: "about-privacy-policy"            }, },
        { title: "クレジット",                            to: { name: "about-credit"                    }, },
        { title: "対局時計",                              to: { name: "vs-clock"                        }, },
        { title: "ストップウォッチ",                      to: { name: "stopwatch"                       }, },
        { title: "符号の鬼",                              to: { name: "xy"                              }, },
        { title: "パーティクルテスト",                    to: { name: "experiment-particle_test",    }  },
        { title: "store 動作検証",                        to: { name: "experiment-store_test"        }, },
        { title: "fetch 動作検証",                        to: { name: "experiment-fetch_test"        }, },
        { title: "users/_id 動作検証",                    to: { name: "experiment-users-id"          }, },
        { title: "DOCTOR",                                to: { name: "experiment-doctor"            }, },
        { title: "フルスクリーンAPIテスト",               to: { name: "experiment-full_screen_api"   }, },
        { title: "フルスクリーンモデルテスト",            to: { name: "experiment-full_screen_model" }, },
        { title: "初期非同期外部IP確認",                  to: { name: "experiment-ip-show"           }, },
        { title: "初期非同期読み込み",                    to: { name: "experiment-async_data_test"   }, },
        { title: "async await の検証",                    to: { name: "experiment-async_await_test"  }, },
        { title: "Bulma動作チェック",                     to: { name: "experiment-bulma_test"        }, },
        { title: "オンラインチェック",                    to: { name: "experiment-online_offline"    }, },
        { title: "YES/NO API",                            to: { name: "experiment-yesno_test"        }, },
        { title: "Inspire",                               to: { name: "inspire"                      }, },
        { title: "404",                                   to: { name: "not_found"                    }, },
        { title: "バイブレーション",                      to: { name: "experiment-VibrateApp"        }, },
        { title: "手番UI検証",                            to: { name: "experiment-OrderUiTest"       }, },
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
