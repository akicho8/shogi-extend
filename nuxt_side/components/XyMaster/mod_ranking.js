const CONGRATS_LTEQ = 10          // N位以内ならおめでとう

import _ from "lodash"
import { HandleNameValidator } from '@/components/models/handle_name/handle_name_validator.js'

export const mod_ranking = {
  data() {
    return {
      entry_name_uniq_p: false, // プレイヤー別順位ON/OFF
    }
  },
  watch: {
    scope_key() {
      this.time_records_hash_update()
    },
    entry_name_uniq_p() {
      this.time_records_hash_update()
    },
  },
  methods: {
    ranking_goal_process() {
      // ログインしていない場合
      if (this.$gs.blank_p(this.g_current_user_name)) {
        this.$gs.delay_block(1.0, () => this.toast_ok("名前を入力してください。できれば入力の手間を省くためにログインしてください"))
        this.name_input_dialog()
        return
      }

      // ログインしているけど名前が不正な場合
      if (HandleNameValidator.invalid_p(this.g_current_user_name)) {
        this.$gs.delay_block(1.0, () => this.toast_ok("適切な名前を入力してください。この入力を省くにはプロフィール編集で適切な名前に変更してください", {duration: 1000 * 5}))
        this.name_input_dialog()
        return
      }

      // ログインしていて名前が問題ない場合
      this.entry_name_set_and_record_post(this.g_current_user_name)
    },

    name_input_dialog() {
      this.dialog_prompt({
        title: "名前を入力してください",
        confirmText: "保存",
        inputAttrs: { type: "text", value: this.entry_name, placeholder: "名前", },
        canCancel: false,
        onConfirm: value => {
          const message = HandleNameValidator.valid_message(value, {name: "名前"})
          if (message) {
            this.sfx_play("x")
            this.toast_warn(message)
            this.name_input_dialog()
          } else {
            this.sfx_click()
            this.entry_name_set_and_record_post(value)
          }
        },
      })
    },

    entry_name_set_and_record_post(value) {
      this.entry_name = value
      this.record_post()
    },

    // 名前を確定してからサーバーに保存する
    async record_post() {
      const params = {
        scope_key: this.scope_key,
        time_record: this.post_params,
      }
      const data = await this.$axios.$post("/api/xy_master/time_records", params)

      this.entry_name_uniq_p = false // 「プレイヤー別順位」の解除
      this.data_update(data)         // ランキングに反映

      // ランク内ならランキングのページをプレイヤーがいるページに移動する
      if (this.current_rank <= this.config.rank_max) {
        this.$set(this.current_pages, this.current_rule_index, this.time_record.rank_info[this.scope_key].page)
      }

      this.talk(this.congrats_message) // おめでとう

      // チャート連動
      if (true) {
        this.chart_rule_key = this.rule_key            // チャートをルールに合わせる
        this.chart_scope_key = "chart_scope_recently"  // 「最近」に変更
        this.chart_data_get_and_show()                 // 表示の更新
      }
    },

    data_update(params) {
      const info = this.RuleInfo.fetch(params.time_record.rule_key)
      this.$set(this.time_records_hash, info.key, params.time_records)
      this.time_record = params.time_record
    },
  },
  computed: {
    post_params() {
      return [
        "rule_key",
        "spent_sec",
        "entry_name",
        "x_count",              // なくてもよい
        "summary",              // なくてもよい
      ].reduce((a, e) => ({...a, [e]: this[e]}), {})
    },

    congrats_message() {
      if (this.entry_name) {
        let str = ""
        str += `${this.entry_name}さん`
        if (this.time_record.rank_info.scope_today.rank <= CONGRATS_LTEQ) {
          str += `おめでとうございます。`
        }
        if (this.time_record.best_update_info) {
          str += `自己ベストを${this.time_record.best_update_info.updated_spent_sec}秒更新しました。`
        }
        const t_r = this.time_record.rank_info.scope_today.rank
        const a_r = this.time_record.rank_info.scope_all.rank
        str += `本日${t_r}位です。`
        str += `全体で`
        if (t_r === a_r) {
          str += `も`
        } else {
          str += `は`
        }
        str += `${a_r}位です。`
        // if (this.current_rank > this.config.rank_max) {
        //   str += `ランキング外です。`
        // }
        return str
      }
    },
  },
}
