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

import "./helper.sass"
import "./flex_box.sass"
import "./general.sass"
import "./application_dependent.sass"
import "./free_battle_edit_ogp_css.sass"

import "./modulable_crud.coffee"

//////////////////////////////////////////////////////////////////////////////// Vue

import Vue from "vue/dist/vue.esm" // esm版はvueのtemplateをパースできる
window.Vue = Vue

import Vuex from "vuex"
Vue.use(Vuex)                   // これは一箇所だけで実行すること。shogi-player 側で実行すると干渉する

import Repository from "./Repository.js"
Vue.prototype.$http = Repository

import "css-browser-selector"   // 読み込んだ時点で htmlタグの class に "mobile" などを付与してくれる

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

import "bulma-extensions/dist/js/bulma-extensions.min.js"
// import "bulma-extensions/dist/css/bulma-extensions.min.css"

//////////////////////////////////////////////////////////////////////////////// lodash

import _ from "lodash"
window._ = _

//////////////////////////////////////////////////////////////////////////////// moment

import moment from "moment"
Object.defineProperty(Vue.prototype, "moment", {value: moment})

//////////////////////////////////////////////////////////////////////////////// Chart.js

import Chart from "chart.js"
window.Chart = Chart

//////////////////////////////////////////////////////////////////////////////// アプリ用の雑多なライブラリ

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

Vue.prototype.LifetimeInfo = LifetimeInfo
Vue.prototype.TeamInfo = TeamInfo
Vue.prototype.LastActionInfo = LastActionInfo
Vue.prototype.CustomPresetInfo = CustomPresetInfo
Vue.prototype.HiraKomaInfo = HiraKomaInfo
Vue.prototype.RobotAcceptInfo = RobotAcceptInfo

//////////////////////////////////////////////////////////////////////////////// どこからでも使いたい2

import vue_basic_methods from "./vue_basic_methods.js"

import shogi_player from "shogi-player/src/components/ShogiPlayer.vue"
import message_link_to from "../message_link_to.vue"
import global_message_link from "../global_message_link.vue"
import swars_user_link_to from "../swars_user_link_to.vue"
import b_icon2 from "../b_icon2.vue"

Vue.mixin({
  mixins: [
    vue_basic_methods,
  ],

  // よくない命名規則だけどこっちの方が開発しやすい
  components: {
    shogi_player,
    message_link_to,
    global_message_link,
    swars_user_link_to,
    "b-icon2": b_icon2,
  },
})

window.GVI = new Vue()           // ActionCable 側から Vue のグローバルなメソッドを呼ぶため

import "./audio_queue.js"
import "./light_session_app.js"

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
