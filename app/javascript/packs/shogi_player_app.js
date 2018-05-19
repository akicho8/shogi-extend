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
    data: function() {
      return {
      }
    },
    methods: {
      wars_tweet_copy_click(wars_tweet_body) {
        AppHelper.clipboard_copy(wars_tweet_body)
      },

      kifu_copy_exec_click: function(e) {
        AppHelper.kifu_copy_exec(e.target.dataset[_.camelCase("kif_direct_access_path")])
      },

      goto_mountain_click: function(e) {
        const url = e.target.dataset[_.camelCase("mountain_url_get_path")]
        axios.get(url, {
          timeout: 1000 * 15,
        }).then((response) => {
          const url = response.data.url
          if (_.isEmpty(url)) {
            this.$toast.open({message: "混み合っているようです", position: "is-bottom", type: "is-danger"})
          } else {
            this.$dialog.confirm({
              message: '準備ができたようです。移動しますか？',
              onConfirm: () => {
                window.open(url, "_blank")
              },
            })
          }
        }).catch((error) => {
          console.table([error.response])
          Vue.prototype.$toast.open({message: error.message, position: "is-bottom", type: "is-danger"})
        })
      }
    },
  })
})
