const TIRESOME_ALERT_TRIGGER = [10, 20, 40, 80, 160]

export const mod_tiresome = {
  data() {
    return {
      mounted_then_query_present_p: null, // 最初に来たとき query の指定があったか？
    }
  },

  mounted() {
    this.$debug.trace("mod_tiresome", "mounted")
    this.mounted_then_query_present_p = this.$gs.present_p(this.$route.query.query)
  },

  methods: {
    tiresome_alert_check() {
      this.$debug.trace("mod_tiresome", "tiresome_alert_check")

      // ページ移動やソート条件を変えたりしているだけなのでスキップ
      if (this.url_prams_without_query_exist_p) {
        return
      }

      // ブックーマークから来たのでスキップ
      if (this.mounted_then_query_present_p) {
        return
      }

      if (this.xi.current_swars_user_key) {
        // 生きているウォーズIDをあとから入力した
        if (this.swars_search_default_key_get()) {
          // すでにウォーズIDを覚えている
        } else {
          // ウォーズIDを覚えていない

          // 前回入力した値と異なるならそこからカウンタを開始する
          if (this.tiresome_previous_user_key != this.xi.current_swars_user_key) {
            this.tiresome_previous_user_key = this.xi.current_swars_user_key
            this.tiresome_count = 0
          }

          this.tiresome_count_increment()
        }
      } else {
        // あとから何か入力したがウォーズIDはわからなかった
      }
    },

    tiresome_count_increment() {
      // ウォーズIDを覚えていない
      // let c = this.user_key_counts[wid] || 0
      // this.$set(this.user_key_counts, wid, c + 1)
      // this.user_key_counts = this.count_hash_reverse_sort_by_count_and_take(this.user_key_counts, 3)
      // this.debug_alert(this.user_key_counts[wid])
      // if (this.tiresome_modal_selected === "none" || this.tiresome_modal_selected === "no") {
      this.tiresome_count += 1
      if (this.tiresome_alert_trigger_hash[this.tiresome_count]) {
        this.tiresome_alert_handle()
      }
      // }
    },

    tiresome_alert_handle() {
      this.$sound.play_click()

      this.$gs.delay_block(1, () => {
        this.$sound.stop_all()
        this.talk("ところでウォーズID毎回入力するの不便じゃない？")
      })

      const subject = "ウォーズID記憶案内"
      this.dialog_confirm({
        canCancel: ["button"],
        // hasIcon: true,
        type: "is-info",
        title: "😐 ところでウォーズID毎回入力するの不便じゃない？",
        message: `
          <div class="">
            <ul class="mt-0">
              <p>
                右上の<b>≡</b>から<b>ウォーズIDを記憶する</b>で入力の手間が省けますよ。
                設定してもあとから<b>元に戻せる</b>ので安心してください。
              </p>
            </ul>
          </div>`,
        confirmText: "やってみる",
        cancelText: "💣 不便なまま生きる",
        onConfirm: () => {
          this.$sound.play("o")
          this.tiresome_modal_selected = "yes"
          this.app_log({emoji: ":CHECK:", subject: subject, body: `[${this.xi.current_swars_user_key}] やってみる`})
        },
        onCancel: () => {
          this.$sound.play("x")
          this.tiresome_modal_selected = "no"
          this.app_log({emoji: ":X:", subject: subject, body: `[${this.xi.current_swars_user_key}] 不便なまま生きる`})
        },
      })
    },
  },

  computed: {
    tiresome_alert_trigger_hash() {
      return TIRESOME_ALERT_TRIGGER.reduce((a, e) => ({...a, [e]: true}), {})
    },

    // query=xxx を除くパラメータがあるか？
    url_prams_without_query_exist_p() {
      const t = {...this.$route.query}
      delete t.query
      return this.$gs.present_p(t)
    },
  },
}
