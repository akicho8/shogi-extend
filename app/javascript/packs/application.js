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

import Chart from "chart.js"
window.Chart = Chart

// 画像をダウンロードしたときに背景色が透明になる問題への対処法
// http://wordpress.ideacompo.com/?p=12888
Chart.plugins.register({
  beforeDraw(c) {
    const ctx = c.chart.ctx
    ctx.fillStyle = "rgba(255, 255, 255, 1)"
    ctx.fillRect(0, 0, c.chart.width, c.chart.height)
  }
})

Chart.defaults.global.elements.line.tension           = 0.2  // 0なら線がカクカクになる
Chart.defaults.global.elements.line.borderWidth       = 1    // 点枠の太さ
Chart.defaults.global.elements.line.fill              = true // 塗り潰す？

Chart.defaults.global.elements.point.radius           = 1.2 // 点半径
Chart.defaults.global.elements.point.hoverRadius      = 5   // 点半径(アクティブ時)
Chart.defaults.global.elements.point.hoverBorderWidth = 2   // 点枠の太さ(アクティブ時)
Chart.defaults.global.elements.point.hitRadius        = 5   // タップできる大きさ

// Chart.defaults.global responsiveAnimationDuration

// Chart.defaults.global.hover.mode = 'dataset'
Chart.defaults.global.hover.mode = 'single'

//////////////////////////////////////////////////////////////////////////////// 通知

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

import vue_application from "support/vue_application.js"
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
import simple_board from "simple_board.vue"
import xy_master from "xy_master.vue"
import cpu_battle from "cpu_battle.vue"
import sp_modal from "sp_modal.vue"
import tactic_modal from "tactic_modal.vue"
import piyo_shogi_button from "components/piyo_shogi_button.vue"
import kento_button from "components/kento_button.vue"
import kif_copy_button from "components/kif_copy_button.vue"
import sp_modal_button from "components/sp_modal_button.vue"
import png_dl_button from "components/png_dl_button.vue"
import tweet_button from "components/tweet_button.vue"

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
    vue_application,
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
    simple_board,
    xy_master,
    cpu_battle,
    sp_modal,
    tactic_modal,
    piyo_shogi_button,
    kento_button,
    kif_copy_button,
    sp_modal_button,
    png_dl_button,
    tweet_button,
  },
})

window.GVI = new Vue()           // ActionCable 側から Vue のグローバルなメソッドを呼ぶため

import "audio_queue.js"
import "light_session_app.js"

import ActionCable from "actioncable"

// このような書き方でいいのかどうかはわからない
window.App = {}
// document.addEventListener('DOMContentLoaded', () => {
//   console.log(window.Vue)
//   console.log(window.GVI)
// })
if (GVI.$route) {
  if (GVI.$route.path.includes("/colosseum/battles")) {
    window.App.cable = ActionCable.createConsumer()
    ActionCable.startDebugging()
  }
}
// import "action_cable_setup.js"
