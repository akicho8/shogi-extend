// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("@rails/activestorage").start()
require("channels")

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

import "modulable_crud.js"
import "global_variable_set.js"

//////////////////////////////////////////////////////////////////////////////// Vue

// async を使うと regeneratorRuntime is not defined になる対策
// よくわからんが .babelrc に書くのではなダメだった
import "babel-polyfill"

import Vue from "vue/dist/vue.esm" // esm版はvueのtemplateをパースできる
window.Vue = Vue

import Vuex from "vuex"
Vue.use(Vuex)                   // これは一箇所だけで実行すること。shogi-player 側で実行すると干渉する

import VueGtag from "vue-gtag"
Vue.use(VueGtag, {
  config: {
    id: 'UA-109851345-1',
    params: {
      // send_page_view: process.env.NODE_ENV !== "production",

      // https://developers.google.com/analytics/devguides/collection/gtagjs/cookies-user-id?hl=ja
      // > サーバーがローカル環境（例: localhost）で実行されていることが検出されると、cookie_domain は自動的に 'none' に設定されます
      // cookie_domain: 'none',
    },
  },
})

import axios_support from "axios_support.js"
Vue.prototype.$http = axios_support

import "css-browser-selector"   // 読み込んだ時点で htmlタグの class に "mobile" などを付与してくれる

//////////////////////////////////////////////////////////////////////////////// Buefy

import "stylesheets/application.sass"
import "bulma_burger.js"

import Buefy from "buefy"
// import "buefy/src/scss/buefy-build.scss" // これか
// import 'buefy/dist/buefy.css'            // これを入れると buefy の初期値に戻ってしまうので注意
Vue.use(Buefy, {
  // https://buefy.org/documentation/constructor-options/
  defaultTooltipType: "is-dark", // デフォルトは背景が明るいため黒くしておく
  defaultTooltipAnimated: true,   // ←効いてなくね？
})

//////////////////////////////////////////////////////////////////////////////// lodash

import _ from "lodash"
window._ = _

//////////////////////////////////////////////////////////////////////////////// Chart.js

import "chart_init.js"

////////////////////////////////////////////////////////////////////////////////

document.addEventListener("DOMContentLoaded", () => {
  if (document.querySelector("#flash_danger_notify_tag")) {
    new Vue({
      el: "#flash_danger_notify_tag",
    })
  }
  if (toast_flash) {
    _.forIn(toast_flash, (message, key) => {
      Vue.prototype.$buefy.toast.open({message: message, position: "is-bottom", type: `is-${key}`, duration: 1000 * 3, queue: false})
    })
  }
})

//////////////////////////////////////////////////////////////////////////////// タブがアクティブか？(見えているか？)

//////////////////////////////////////////////////////////////////////////////// どこからでも使いたい2

import vue_mixins from "vue_mixins/vue_mixins.js"

// Components
import shogi_player                    from "shogi-player/src/components/ShogiPlayer.vue"
import swars_user_link_to              from "swars_user_link_to.vue"
import pulldown_menu                   from "pulldown_menu.vue"
import buefy_table_wrapper             from "buefy_table_wrapper.vue"
import custom_chart                    from "custom_chart.vue"
import acns1_sample                    from "acns1_sample.vue"
import simple_board                    from "simple_board.vue"
import sp_show                         from "sp_show.vue"
import ox_modal                        from "ox_modal.vue"
import tactic_show                     from "tactic_show.vue"
import piyo_shogi_button               from "components/piyo_shogi_button.vue"
import kento_button                    from "components/kento_button.vue"
import kif_copy_button                 from "components/kif_copy_button.vue"
import sp_show_button                  from "components/sp_show_button.vue"
import png_dl_button                   from "components/png_dl_button.vue"
import tweet_button                    from "components/tweet_button.vue"
import membership_medal                from "components/membership_medal.vue"
import win_lose_circle                 from "win_lose_circle.vue"

Vue.mixin({
  mixins: [
    vue_mixins,
  ],

  // よくない命名規則だけどこっちの方が開発しやすい
  components: {
    shogi_player,
    swars_user_link_to,
    pulldown_menu,
    simple_board,
    sp_show,
    ox_modal,
    win_lose_circle,
    buefy_table_wrapper,
    custom_chart,
    acns1_sample,

    // for buefy modal
    tactic_show,

    // buttons
    piyo_shogi_button,
    kento_button,
    kif_copy_button,
    sp_show_button,
    png_dl_button,
    tweet_button,

    // icon
    membership_medal,
  },
})

window.GVI = new Vue()           // ActionCable 側から Vue のグローバルなメソッドを呼ぶため

import "audio_queue.js"

window.App = {}
