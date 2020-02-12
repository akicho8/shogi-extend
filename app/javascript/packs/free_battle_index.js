import battle_index_mod from "battle_index_mod.js"

window.FreeBattleIndex = Vue.extend({
  mixins: [battle_index_mod],

  data() {
    return {
      detailed: false,           // 行の下に開くやつを使う？
    }
  },

  mounted() {
    // クエリーがなくても表示する
    // if (this.query) {
    // }
    this.async_records_load()
  },
})
