import battle_index_shared from "./battle_index_shared.js"

window.FreeBattleIndex = Vue.extend({
  mixins: [battle_index_shared],

  data() {
    return {
      detailed: false,           // 行の下に開くやつを使う？
    }
  },
})
