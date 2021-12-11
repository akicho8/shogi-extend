const TIRESOME_ALERT_TRIGGER = [4, 8, 16, 32, 64, 128]

import { MyLocalStorage  } from "@/components/models/my_local_storage.js"

export const app_tiresome = {
  data() {
    return {
      mounted_then_query_present_p: null, // 最初に来たとき query の指定があったか？
    }
  },

  mounted() {
    this.__trace__("app_tiresome", "mounted")
    this.mounted_then_query_present_p = this.present_p(this.$route.query.query)
  },

  methods: {
    tiresome_alert_check() {
      this.__trace__("app_tiresome", "tiresome_alert_check")
      if (this.mounted_then_query_present_p) {
        // ブックーマークから来たのでスキップ
      } else {
        if (this.config.current_swars_user_key) {
          // 生きているウォーズIDをあとから入力した
          if (this.swars_search_default_key_exist_p()) {
            // すでにウォーズIDを覚えている
          } else {
            // ウォーズIDを覚えていない
            // let c = this.user_key_counts[wid] || 0
            // this.$set(this.user_key_counts, wid, c + 1)
            // this.user_key_counts = this.count_hash_reverse_sort_by_count_and_take(this.user_key_counts, 3)
            // this.debug_alert(this.user_key_counts[wid])
            this.tiresome_count += 1
            if (this.tiresome_alert_trigger_hash[this.tiresome_count]) {
              this.tiresome_alert_handle()
            }
          }
        } else {
          // あとから何か入力したがウォーズIDはわからなかった
        }
      }
    },

    // ウォーズIDを覚えているか？
    swars_search_default_key_exist_p() {
      return MyLocalStorage.get("swars_search_default_key")
    },

    tiresome_alert_handle() {
      this.sound_play_click()

      this.delay_block(1, () => {
        this.sound_stop_all()
        this.talk("ウォーズIDを毎回入力する必要はありません。右上メニューからウォーズIDを覚えるで入力の手間が省けます")
      })

      this.dialog_alert({
        hasIcon: true,
        type: "is-info",
        title: "ウォーズIDを毎回入力する必要はありません",
        message: `右上メニューから<b>ウォーズIDを覚える</b>で入力の手間が省けます`,
        confirmText: "わかった",
      })
    },
  },

  computed: {
    tiresome_alert_trigger_hash() {
      return TIRESOME_ALERT_TRIGGER.reduce((a, e) => ({...a, [e]: true}), {})
    },
  },
}
