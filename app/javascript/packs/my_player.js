import Vue from 'vue/dist/vue.esm'
import ShogiPlayer from 'shogi_player/src/components/ShogiPlayer.vue'

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    el: '#shogi_player_app',
    components: { "shogi_player": ShogiPlayer }
  })
})
