const CONGRATS_LTEQ = 10      // N位以内ならおめでとう

import _ from "lodash"

export const app_ranking = {
  data() {
    return {
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
      if (this.current_entry_name) {
        this.entry_name = this.current_entry_name
        this.record_post()
      } else {
        this.$buefy.dialog.prompt({
          title: "名前を入力してください",
          confirmText: "保存",
          cancelText: "キャンセル",
          inputAttrs: { type: "text", value: this.entry_name, placeholder: "名前", },
          canCancel: false,
          onConfirm: value => {
            this.entry_name = _.trim(value)
            if (this.present_p(this.entry_name)) {
              this.record_post()
            }
          },
        })
      }
    },

    // 名前を確定してからサーバーに保存する
    async record_post() {
      const params = {
        scope_key: this.scope_key,
        time_record:    this.post_params,
      }
      const data = await this.$axios.$post("/api/xy_master/time_records", params)

      this.entry_name_uniq_p = false // 「プレイヤー別順位」の解除
      this.data_update(data)         // ランキングに反映

      // ランク内ならランキングのページをそのページに移動する
      if (this.current_rank <= this.config.rank_max) {
        this.$set(this.current_pages, this.current_rule_index, this.time_record.rank_info[this.scope_key].page)
      }

      // おめでとう
      this.congrats_talk()

      // チャートの表示状態をゲームのルールに合わせて「最近」にして更新しておく
      this.chart_rule_key = this.rule_key
      this.chart_scope_key = "chart_scope_recently"
      this.chart_data_get_and_show()
    },

    data_update(params) {
      const rule_info = this.RuleInfo.fetch(params.time_record.rule_key)
      this.$set(this.time_records_hash, rule_info.key, params.time_records)
      this.time_record = params.time_record
    },

    congrats_talk() {
      let message = ""
      if (this.entry_name) {
        message += `${this.entry_name}さん`
        if (this.time_record.rank_info.scope_today.rank <= CONGRATS_LTEQ) {
          message += `おめでとうございます。`
        }
        if (this.time_record.best_update_info) {
          message += `自己ベストを${this.time_record.best_update_info.updated_spent_sec}秒更新しました。`
        }
        const t_r = this.time_record.rank_info.scope_today.rank
        const a_r = this.time_record.rank_info.scope_all.rank
        message += `本日${t_r}位です。`
        message += `全体で`
        if (t_r === a_r) {
          message += `も`
        } else {
          message += `は`
        }
        message += `${a_r}位です。`
        // if (this.current_rank > this.config.rank_max) {
        //   message += `ランキング外です。`
        // }
        this.talk(message)
      }
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
  },
}
