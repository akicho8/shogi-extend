import Vue from 'vue/dist/vue.esm'
import Add1 from 'shogi_player/src/components/HelloPlayer.vue'

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    el: '#shogi_player_area',
    components: { "shogi_player": Add1 }
  })
})
