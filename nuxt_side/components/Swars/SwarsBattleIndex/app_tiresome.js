const TIRESOME_ALERT_TRIGGER = [8, 16, 32, 64, 128]

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
        if (this.xi.current_swars_user_key) {
          // 生きているウォーズIDをあとから入力した
          if (this.swars_search_default_key_get()) {
            // すでにウォーズIDを覚えている
          } else {
            // ウォーズIDを覚えていない
            this.tiresome_count_increment()
          }
        } else {
          // あとから何か入力したがウォーズIDはわからなかった
        }
      }
    },

    tiresome_count_increment() {
      // ウォーズIDを覚えていない
      // let c = this.user_key_counts[wid] || 0
      // this.$set(this.user_key_counts, wid, c + 1)
      // this.user_key_counts = this.count_hash_reverse_sort_by_count_and_take(this.user_key_counts, 3)
      // this.debug_alert(this.user_key_counts[wid])
      // if (this.tiresome_key === "none" || this.tiresome_key === "no") {
      this.tiresome_count += 1
      if (this.tiresome_alert_trigger_hash[this.tiresome_count]) {
        this.tiresome_alert_handle()
      }
      // }
    },

    tiresome_alert_handle() {
      this.sound_play_click()

      this.delay_block(1, () => {
        this.sound_stop_all()
        this.talk("ウォーズIDを毎回入力する必要はありません。右上メニューからウォーズIDを覚えるで入力の手間が省けます")
      })

      const subject = "ウォーズIDを覚える案内発動"
      this.dialog_confirm({
        canCancel: ["button"],
        hasIcon: true,
        type: "is-info",
        title: "ウォーズIDを毎回入力する必要はありません",
        message: `<b>右上メニュー</b>から<b>ウォーズIDを覚える</b>で入力の手間が省けます<br>`,
        confirmText: "やってみる",
        cancelText: "面倒なままでいい",
        onConfirm: () => {
          this.sound_play_click()
          this.tiresome_key = "yes"
          this.remote_notify({subject: subject, body: "やってみる"})
        },
        onCancel: () => {
          this.sound_play_click()
          this.tiresome_key = "no"
          this.remote_notify({subject: subject, body: "面倒なままでいい"})
        },
      })
    },
  },

  computed: {
    tiresome_alert_trigger_hash() {
      return TIRESOME_ALERT_TRIGGER.reduce((a, e) => ({...a, [e]: true}), {})
    },
  },
}
