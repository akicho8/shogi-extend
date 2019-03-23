// import Vue from 'vue/dist/vue.esm'
// import Buefy from 'buefy'
// Vue.use(Buefy)
// window.Vue = Vue

//////////////////////////////////////////////////////////////////////////////// Buefy

// import Vue from 'vue'

// import Vue from 'vue/dist/vue.esm'

// import ShogiPlayer from 'shogi-player/src/components/ShogiPlayer.vue'
//
import _ from "lodash"
// Object.defineProperty(Vue.prototype, '_', {value: _})

// Vue.component('shogi-player', ShogiPlayer)

import * as AppHelper from "./app_helper.js"

import axios from "axios"

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#shogi_player_app',
    data() {
      return {
      }
    },
    methods: {
      wars_tweet_copy_click(wars_tweet_body) {
        AppHelper.clipboard_copy(wars_tweet_body)
      },

      kifu_copy_exec_click(e) {
        AppHelper.kifu_copy_exec(e.target.dataset[_.camelCase("kif_direct_access_path")])
      },
    },
  })
})
