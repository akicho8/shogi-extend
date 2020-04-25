import _ from "lodash"
import dayjs from "dayjs"
import battle_record_methods from "battle_record_methods.js"
import formal_sheet from "formal_sheet.js"

export default {
  mixins: [
    battle_record_methods,
    formal_sheet,
  ],

  data() {
    return {
      record: this.$options.record,
      iframe_p: this.$options.iframe_p,
    }
  },

  mounted() {
    if (this.$route.query.formal_sheet === "true") {
      // 棋譜印刷モード
    } else {
      if (this.iframe_p) {
        // iframeモード
      } else {
        // 通常の詳細(TODO: iframeの場合は表示しない)
        this.sp_show_modal({record: this.record})
      }
    }
  },

  watch: {
    // sp_show_p(v) {
    //   if (v) {
    //   } else {
    //     if (this.$options.close_back_path) {
    //       this.url_open(this.$options.close_back_path)
    //     }
    //   }
    // },
  },
}
