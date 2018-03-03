// import Vue from 'vue/dist/vue.esm'
// import Buefy from 'buefy'
// Vue.use(Buefy)
// window.Vue = Vue

//////////////////////////////////////////////////////////////////////////////// Buefy

// import Vue from 'vue'

// import Vue from 'vue/dist/vue.esm'

// import ShogiPlayer from 'shogi-player/src/components/ShogiPlayer.vue'
//
// import _ from "lodash"
// Object.defineProperty(Vue.prototype, '_', {value: _})

// Vue.component('shogi-player', ShogiPlayer)

import * as AppUtils from "./app_utils.js"

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#shogi_player_app',
    // mounted: function () {
    //   kifu_copy_hook_all()
    // },
    // components: { ShogiPlayer },
    data: function() {
      return {}
    },
    methods: {
      this_kifu_copy_exec: function(e) {
        AppUtils.kifu_copy_exec(e.target.dataset.kifDirectAccessPath) // kif_direct_access_path
      },
      this_goto_mountain: function(e) {
        alert(e.target.dataset.href2)
        // const kifu_text = $.ajax({type: "GET", url: url, async: false}).responseText
      }
    },
  })
})
