/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

// import "bulma"
import "./application_css.sass"
// import "./bootstrap_tuning.sass"

import "./modulable_crud.coffee"

//////////////////////////////////////////////////////////////////////////////// Vue

import Vue from 'vue/dist/vue.esm'
window.Vue = Vue

//////////////////////////////////////////////////////////////////////////////// Buefy

// import Vue from 'vue'
import Buefy from 'buefy'
import 'buefy/lib/buefy.css'
Vue.use(Buefy)

// // From outside Vue instance
// import { Toast, ModalProgrammatic } from 'buefy'
// Toast

// // OR
//
// Vue.component(Buefy.Checkbox.name, Buefy.Checkbox);
// Vue.component(Buefy.Table.name, Buefy.Table);
// Vue.component(Buefy.Switch.name, Buefy.Switch);

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

////////////////////////////////////////////////////////////////////////////////

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
////////////////////////////////////////////////////////////////////////////////

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#app_notification_tag',
  })
})
