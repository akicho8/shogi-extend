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

import "./application_css.sass"
import "./modulable_crud.coffee"
import "./bulma.js"
import "./light_session_app.js"
import "./audio_queue.js"

//////////////////////////////////////////////////////////////////////////////// Vue

import Vue from "vue/dist/vue.esm"
window.Vue = Vue

import Vuex from "vuex"
Vue.use(Vuex)

//////////////////////////////////////////////////////////////////////////////// Buefy

import Buefy from "buefy"
import "buefy/lib/buefy.css"
Vue.use(Buefy)

//////////////////////////////////////////////////////////////////////////////// ShogiPlayer

import ShogiPlayer from "shogi-player/src/components/ShogiPlayer.vue"
Vue.component("shogi-player", ShogiPlayer)

import PresetInfo from "shogi-player/src/preset_info"
Object.defineProperty(Vue.prototype, "PresetInfo", {value: PresetInfo})

import RunModeInfo from "shogi-player/src/run_mode_info"
Object.defineProperty(Vue.prototype, "RunModeInfo", {value: RunModeInfo})

import ThemeInfo from "shogi-player/src/theme_info"
Object.defineProperty(Vue.prototype, "ThemeInfo", {value: ThemeInfo})

import SizeInfo from "shogi-player/src/size_info"
Object.defineProperty(Vue.prototype, "SizeInfo", {value: SizeInfo})

import VariationInfo from "shogi-player/src/variation_info"
Object.defineProperty(Vue.prototype, "VariationInfo", {value: VariationInfo})

//////////////////////////////////////////////////////////////////////////////// 静的情報

import LifetimeInfo from "./lifetime_info"
Object.defineProperty(Vue.prototype, "LifetimeInfo", {value: LifetimeInfo})

import TeamInfo from "./team_info"
Object.defineProperty(Vue.prototype, "TeamInfo", {value: TeamInfo})

import LastActionInfo from "./last_action_info"
Object.defineProperty(Vue.prototype, "LastActionInfo", {value: LastActionInfo})

import CustomPresetInfo from "./custom_preset_info"
Object.defineProperty(Vue.prototype, "CustomPresetInfo", {value: CustomPresetInfo})

import HiraKomaInfo from "./hira_koma_info"
Object.defineProperty(Vue.prototype, "HiraKomaInfo", {value: HiraKomaInfo})

import RobotAcceptInfo from "./robot_accept_info"
Object.defineProperty(Vue.prototype, "RobotAcceptInfo", {value: RobotAcceptInfo})

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
