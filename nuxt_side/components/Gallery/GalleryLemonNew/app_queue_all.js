export const app_queue_all = {
  data() {
    return {
      gallery_info: null,
    }
  },

  methods: {
    // 変換状況を受けとる
    lemon_list_broadcasted(data) {
      this.gallery_info = data
      this.gallery_info.lemons = this.gallery_info.lemons.map(e => new this.Lemon(this, e))
    },
  },
}
