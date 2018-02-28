import Vue from 'vue/dist/vue.esm'
import ShogiPlayer from 'shogi-player/src/components/ShogiPlayer.vue'

import _ from "lodash"
Object.defineProperty(Vue.prototype, '_', {value: _})

// Vue.component('shogi-player', ShogiPlayer)

document.addEventListener('DOMContentLoaded', () => {
  var foobar = new Vue({
    el: '#shogi_player_app',
    data: function() {
      return {
        foo: "",
      }
    },
    components: { ShogiPlayer },
  })
})
