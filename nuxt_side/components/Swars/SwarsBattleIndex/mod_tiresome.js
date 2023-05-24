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

      if (this.url_prams_without_query_exist_p) {
        // ページ移動やソート条件を変えたりしているだけなのでスキップ
        return
      }

      if (this.mounted_then_query_present_p) {
        // ブックーマークから来たのでスキップ
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

      const subject = `ウォーズID記憶案内 [${this.xi.current_swars_user_key}]`
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
          this.app_log({emoji: ":CHECK:", subject: subject, body: `やってみる`})
        },
        onCancel: () => {
          this.$sound.play("x")
          this.tiresome_modal_selected = "no"
          this.app_log({emoji: ":X:", subject: subject, body: `不便なまま生きる`})
        },
      })
    },

    // counts_hash_reverse_sort_take({ a: 1, c: 3, b: 2, d: 4 }, 3) => {:d=>4, :c=>3, :b=>2}
    // count_hash_reverse_sort_by_count_and_take(hash, n) {
    //   let list = this.hash_to_key_value_list(hash)
    //   list = _.sortBy(list, [e => -e.value])
    //   list = _.take(list, n)
    //   return this.key_value_list_to_hash(list)
    // },

    // key, value のキーをもった配列から hash に戻す
    // key_value_list_to_hash(ary) {
    //   return ary.reduce((a, e) => ({...a, [e.key]: e.value}), {})
    // },

    // { a: 1, c: 3, b: 2, d: 4 }.sort_by { |k, v| -v }.take(3).to_h # => {:d=>4, :c=>3, :b=>2}
    //
    // ↓
    //
    // let list = this.hash_to_key_value_list(hash)
    // list = _.sortBy(list, [e => -e.value])
    // list = _.take(list, 3)
    // hash = this.key_value_list_to_hash(list)

    // hash を key, value のキーをもった配列にする
    // hash_to_key_value_list(hash) {
    //   return _.reduce(hash, (a, value, key) => {
    //     a.push({key: key, value: value})
    //     return a
    //   }, [])
    // },
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
