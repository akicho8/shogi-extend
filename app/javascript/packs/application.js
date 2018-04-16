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

//////////////////////////////////////////////////////////////////////////////// Vue

import Vue from 'vue/dist/vue.esm'
window.Vue = Vue

//////////////////////////////////////////////////////////////////////////////// Buefy

import Buefy from 'buefy'
import 'buefy/lib/buefy.css'
Vue.use(Buefy)

//////////////////////////////////////////////////////////////////////////////// ShogiPlayer

// import { PresetInfo } from 'shogi-player/src/preset_info.js'
// Object.defineProperty(Vue.prototype, 'PresetInfo', {value: PresetInfo})

import ShogiPlayer from 'shogi-player/src/components/ShogiPlayer.vue'
Vue.component('shogi-player', ShogiPlayer)

import Vuex from "vuex"
Vue.use(Vuex)

//////////////////////////////////////////////////////////////////////////////// lodash

import _ from "lodash"
Object.defineProperty(Vue.prototype, '_', {value: _})

//////////////////////////////////////////////////////////////////////////////// アプリ用の雑多なライブラリ

import * as AppUtils from "./app_utils.js"

////////////////////////////////////////////////////////////////////////////////

// import ShogiPlayer from 'shogi-player/src/components/ShogiPlayer.vue'
//
// import _ from "lodash"
// Object.defineProperty(Vue.prototype, '_', {value: _})
//
// Vue.component('shogi-player', ShogiPlayer)

// document.addEventListener('DOMContentLoaded', () => {
//   new Vue({
//     el: '#shogi_player_app',
//     components: { ShogiPlayer },
//   })
// })

//////////////////////////////////////////////////////////////////////////////// 最初からあるDOMに kifu_copy_hook_all 適用

document.addEventListener('DOMContentLoaded', () => {
  AppUtils.kifu_copy_hook_all()
})

//////////////////////////////////////////////////////////////////////////////// 通知

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#app_notification_tag',
  })
})

//////////////////////////////////////////////////////////////////////////////// 確認用

if (typeof(jQuery) != "undefined") {
  console.log('[Webpack] jQuery: OK')
  if (typeof($) != "undefined") {
    console.log('[Webpack] $: OK')
    if (typeof($().tooltip) != "undefined") {
      console.log('[Webpack] Bootstrap JS: OK')
    } else {
      console.log('[Webpack] Bootstrap JS: Missing')
    }
  } else {
    console.log('[Webpack] $: Missing')
  }
} else {
  console.log('[Webpack] jQuery: Missing')
}
if (typeof(Vue) != "undefined") {
  console.log('[Webpack] Vue: OK')
} else {
  console.log('[Webpack] Vue: Missing')
}
