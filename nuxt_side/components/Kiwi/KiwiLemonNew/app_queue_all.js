export const app_queue_all = {
  data() {
    return {
      kiwi_info: null,
    }
  },

  methods: {
    // 変換状況を受けとる
    lemon_list_broadcasted(data) {
      this.kiwi_info = data
      this.kiwi_info.lemons = this.kiwi_info.lemons.map(e => new this.Lemon(this, e))
    },
  },
}
