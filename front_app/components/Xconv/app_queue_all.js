export const app_queue_all = {
  data() {
    return {
      xconv_info: null,
    }
  },

  methods: {
    // 変換状況を受けとる
    xconv_record_list_broadcasted(data) {
      this.xconv_info = data
    },
  },
}
