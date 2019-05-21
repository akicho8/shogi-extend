import battle_index_shared from "./battle_index_shared.js"

import _ from "lodash"
import * as AppHelper from "./app_helper.js"
import axios from "axios"
import dayjs from "dayjs"

window.SwarsBattleIndex = Vue.extend({
  mixins: [battle_index_shared],

  data() {
    return {
      submited: false,
      // detailed: false,
    }
  },

  mounted() {
  },

  methods: {
    many_import_handle(e) {
      Vue.prototype.$dialog.confirm({
        // title: "どうする？",
        message: "1分ぐらいかかる場合がありますがよろしいですか？",
        confirmText: "実行する",
        cancelText: "やめとく",
        focusOn: "cancel",
        onConfirm: () => {
          this.process_now()
          this.$refs.many_import_link.click()
        },
        onCancel: () => {
          AppHelper.talk("やめときました")
        },
      })
    },

    form_submited(e) {
      this.process_now()

      this.submited = true
    },
  },
})
