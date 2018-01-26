import Vue from 'vue/dist/vue.esm'
import ShogiPlayer from 'shogi-player/src/components/ShogiPlayer.vue'

import _ from "lodash"
Object.defineProperty(Vue.prototype, '_', {value: _})

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#shogi_player_app',
    components: { "shogi_player": ShogiPlayer }
  })
})
