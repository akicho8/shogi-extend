/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import Rails from "rails-ujs"
Rails.start()

import "./general.sass"
import "./application_dependent.sass"
import "./modulable_crud.coffee"
import "./light_session_app.js"
import "./audio_queue.js"

import "css-browser-selector"   // 読み込んだ時点で htmlタグの class に "mobile" などを付与してくれる

//////////////////////////////////////////////////////////////////////////////// Vue

import Vue from "vue/dist/vue.esm" // esm版はvueのtemplateをパースできる
window.Vue = Vue

import Vuex from "vuex"
Vue.use(Vuex)                   // これは一箇所だけで実行すること。shogi-player 側で実行すると干渉する

//////////////////////////////////////////////////////////////////////////////// Buefy

import "./buefy.scss"
import "./bulma_burger.js"

import Buefy from "buefy"
// import "buefy/src/scss/buefy-build.scss" // これか
// import 'buefy/dist/buefy.css'            // これを入れると buefy の初期値に戻ってしまうので注意
Vue.use(Buefy, {
  // https://buefy.org/documentation/constructor-options/
  defaultTooltipType: "is-black", // デフォルトは背景が明るいため黒くしておく
  defaultTooltipAnimated: true,   // ←効いてなくね？
})

//////////////////////////////////////////////////////////////////////////////// ShogiPlayer

// import ShogiPlayer from "shogi-player/src/components/ShogiPlayer.vue"
// Vue.component("shogi-player", ShogiPlayer)

//////////////////////////////////////////////////////////////////////////////// チャット関連コンポーネント

import MessageLinkTo from "../message_link_to.vue"
Vue.component("message_link_to", MessageLinkTo)

import GlobalMessageLink from "../global_message_link.vue"
Vue.component("global_message_link", GlobalMessageLink)

//////////////////////////////////////////////////////////////////////////////// lodash

import _ from "lodash"
Object.defineProperty(Vue.prototype, "_", {value: _})

//////////////////////////////////////////////////////////////////////////////// moment

import moment from "moment"
Object.defineProperty(Vue.prototype, "moment", {value: moment})

//////////////////////////////////////////////////////////////////////////////// Chart.js

import Chart from "chart.js"
window.Chart = Chart

//////////////////////////////////////////////////////////////////////////////// アプリ用の雑多なライブラリ

import * as AppHelper from "./app_helper.js"
window.AppHelper = AppHelper    // こうしとけばどこからでも直接使える

////////////////////////////////////////////////////////////////////////////////

// import ShogiPlayer from "shogi-player/src/components/ShogiPlayer.vue"
//
// import _ from "lodash"
// Object.defineProperty(Vue.prototype, "_", {value: _})
//
// Vue.component("shogi-player", ShogiPlayer)

// document.addEventListener("DOMContentLoaded", () => {
//   new Vue({
//     el: "#shogi_player_app",
//     components: { ShogiPlayer },
//   })
// })

//////////////////////////////////////////////////////////////////////////////// 最初からあるDOMに kifu_copy_hook_all 適用

document.addEventListener("DOMContentLoaded", () => {
  AppHelper.kifu_copy_hook_all()
})

//////////////////////////////////////////////////////////////////////////////// 通知

document.addEventListener("DOMContentLoaded", () => {
  new Vue({
    el: "#flash_danger_notify_tag",
  })
})

//////////////////////////////////////////////////////////////////////////////// どこからでも使いたい

import LifetimeInfo from "./lifetime_info"
import TeamInfo from "./team_info"
import LastActionInfo from "./last_action_info"
import CustomPresetInfo from "./custom_preset_info"
import HiraKomaInfo from "./hira_koma_info"
import RobotAcceptInfo from "./robot_accept_info"

import ShogiPlayer from "shogi-player/src/components/ShogiPlayer.vue"

Vue.mixin({
  components: {
    ShogiPlayer,
  },

  data() {
    return {
      LifetimeInfo,
      TeamInfo,
      LastActionInfo,
      CustomPresetInfo,
      HiraKomaInfo,
      RobotAcceptInfo,
    }
  },

  methods: {
    process_now() {

      // this.$modal.open()

      this.$dialog.alert({
        title: "処理中",
        message: "しばらくお待ちください",
        type: "is-primary",
        // hasIcon: true,
        // icon: "crown",
        // iconPack: "mdi",
      })

      this.$loading.open()
    },

    wars_tweet_copy_click(wars_tweet_body) {
      AppHelper.clipboard_copy({text: wars_tweet_body})
    },

    kifu_copy_exec_click(e) {
      const params = JSON.parse(e.target.dataset[_.camelCase("kifu_copy_params")])
      AppHelper.kifu_copy_exec(params)
    },

    debug_alert(message) {
      if (process.env.NODE_ENV === "development") {
        this.$toast.open({message: message, position: "is-bottom", type: "is-danger"})
      }
    },
  },
})

//////////////////////////////////////////////////////////////////////////////// 確認用

if (typeof(jQuery) != "undefined") {
  console.log("[Webpack] jQuery: OK")
  if (typeof($) != "undefined") {
    console.log("[Webpack] $: OK")
    if (typeof($().tooltip) != "undefined") {
      console.log("[Webpack] Bootstrap JS: OK")
    } else {
      console.log("[Webpack] Bootstrap JS: Missing")
    }
  } else {
    console.log("[Webpack] $: Missing")
  }
} else {
  console.log("[Webpack] jQuery: Missing")
}
if (typeof(Vue) != "undefined") {
  console.log("[Webpack] Vue: OK")
} else {
  console.log("[Webpack] Vue: Missing")
}
