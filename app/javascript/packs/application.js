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

import "action_cable_setup.js"
import "modulable_crud.js"
import "rails_env_set.js"

//////////////////////////////////////////////////////////////////////////////// Vue

import Vue from "vue/dist/vue.esm" // esm版はvueのtemplateをパースできる
window.Vue = Vue

import Vuex from "vuex"
Vue.use(Vuex)                   // これは一箇所だけで実行すること。shogi-player 側で実行すると干渉する

import VueRouter from "vue-router"
Vue.use(VueRouter)

import Repository from "Repository.js"
Vue.prototype.$http = Repository

import "css-browser-selector"   // 読み込んだ時点で htmlタグの class に "mobile" などを付与してくれる

//////////////////////////////////////////////////////////////////////////////// Buefy

import "application.sass"
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

import Chart from "chart.js"
window.Chart = Chart

//////////////////////////////////////////////////////////////////////////////// 通知

document.addEventListener("DOMContentLoaded", () => {
  if (document.querySelector("#flash_danger_notify_tag")) {
    new Vue({
      el: "#flash_danger_notify_tag",
    })
  }
})

//////////////////////////////////////////////////////////////////////////////// タブがアクティブか？(見えているか？)

window.tab_is_active_p = () => {
  console.log("document.hidden", document.hidden)
  console.log("document.visibilityState", document.visibilityState)
  return !(document.hidden || document.visibilityState === "hidden")
}

//////////////////////////////////////////////////////////////////////////////// どこからでも使いたい

import LifetimeInfo from "lifetime_info"
import TeamInfo from "team_info"
import LastActionInfo from "last_action_info"
import CustomPresetInfo from "custom_preset_info"
import HiraKomaInfo from "hira_koma_info"
import RobotAcceptInfo from "robot_accept_info"

Vue.prototype.LifetimeInfo = LifetimeInfo
Vue.prototype.TeamInfo = TeamInfo
Vue.prototype.LastActionInfo = LastActionInfo
Vue.prototype.CustomPresetInfo = CustomPresetInfo
Vue.prototype.HiraKomaInfo = HiraKomaInfo
Vue.prototype.RobotAcceptInfo = RobotAcceptInfo

//////////////////////////////////////////////////////////////////////////////// どこからでも使いたい2

import vue_support from "support/vue_support.js"
import vue_fetch from "support/vue_fetch.js"
import vue_clipboard from "support/vue_clipboard.js"
import vue_sound from "support/vue_sound.js"

import shogi_player from "shogi-player/src/components/ShogiPlayer.vue"
import message_link_to from "message_link_to.vue"
import global_message_link from "global_message_link.vue"
import swars_user_link_to from "swars_user_link_to.vue"
import pulldown_menu from "pulldown_menu.vue"
import stopwatch from "stopwatch.vue"
import vs_clock from "vs_clock.vue"
import xy_game from "xy_game.vue"
import cpu_battle from "cpu_battle.vue"

// const router = new VueRouter({
//   mode: 'history',
//   // base: process.env.BASE_URL,
//   // linkActiveClass: "is-active", // router-link-exact-active
//   routes: [
//   ],
// })

Vue.mixin({
  router: new VueRouter({mode: "history"}),

  mixins: [
    vue_support,
    vue_fetch,
    vue_clipboard,
    vue_sound,
  ],

  // よくない命名規則だけどこっちの方が開発しやすい
  components: {
    shogi_player,
    message_link_to,
    global_message_link,
    swars_user_link_to,
    pulldown_menu,
    stopwatch,
    vs_clock,
    xy_game,
    cpu_battle,
  },
})

window.GVI = new Vue()           // ActionCable 側から Vue のグローバルなメソッドを呼ぶため

import "audio_queue.js"
import "light_session_app.js"
