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

import * as AppUtils from "./app_utils.js"

import axios from "axios"

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
        AppUtils.kifu_copy_exec(e.target.dataset[_.camelCase("kif_direct_access_path")])
      },

      this_goto_mountain: function(e) {
        const url = e.target.dataset[_.camelCase("mountain_url_get_path")]
        axios.get(url, {
          timeout: 1000 * 3,
        }).then((response) => {
          const url = response.data.url
          if (url === "") {
            Vue.prototype.$toast.open({message: "混み合っているようです", position: "is-bottom", type: "is-danger"})
          } else {
            window.open(url, "_blank")
          }
        }).catch((error) => {
          console.table([error.response])
          Vue.prototype.$toast.open({message: error.message, position: "is-bottom", type: "is-danger"})
        })
      }
    },
  })
})
