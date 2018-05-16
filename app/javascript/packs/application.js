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

//////////////////////////////////////////////////////////////////////////////// Vue

import Vue from "vue/dist/vue.esm"
window.Vue = Vue

//////////////////////////////////////////////////////////////////////////////// Buefy

import Buefy from "buefy"
import "buefy/lib/buefy.css"
Vue.use(Buefy)

//////////////////////////////////////////////////////////////////////////////// ShogiPlayer

import ShogiPlayer from "shogi-player/src/components/ShogiPlayer.vue"
Vue.component("shogi-player", ShogiPlayer)

// FIXME: これどうにからんか？
import { PresetInfo } from "shogi-player/src/preset_info.js"
import { RunModeInfo } from "shogi-player/src/run_mode_info.js"
import { ThemeInfo } from "shogi-player/src/theme_info.js"
import { SizeInfo } from "shogi-player/src/size_info.js"
import { VariationInfo } from "shogi-player/src/variation_info.js"

Object.defineProperty(Vue.prototype, 'PresetInfo', {value: PresetInfo})
Object.defineProperty(Vue.prototype, 'RunModeInfo', {value: RunModeInfo})
Object.defineProperty(Vue.prototype, 'ThemeInfo', {value: ThemeInfo})
Object.defineProperty(Vue.prototype, 'SizeInfo', {value: SizeInfo})
Object.defineProperty(Vue.prototype, 'VariationInfo', {value: VariationInfo})

import Vuex from "vuex"
Vue.use(Vuex)

//////////////////////////////////////////////////////////////////////////////// チャット関連コンポーネント

import Messanger from "../messenger.vue"
Vue.component("messenger", Messanger)

//////////////////////////////////////////////////////////////////////////////// lodash

import _ from "lodash"
Object.defineProperty(Vue.prototype, "_", {value: _})

//////////////////////////////////////////////////////////////////////////////// moment

import moment from "moment"
Object.defineProperty(Vue.prototype, "moment", {value: moment})

//////////////////////////////////////////////////////////////////////////////// アプリ用の雑多なライブラリ

import * as AppUtils from "./app_utils.js"

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
  AppUtils.kifu_copy_hook_all()
})

//////////////////////////////////////////////////////////////////////////////// 通知

document.addEventListener("DOMContentLoaded", () => {
  new Vue({
    el: "#flash_danger_notification_tag",
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
