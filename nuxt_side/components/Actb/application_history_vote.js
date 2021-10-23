export const application_history_vote = {
  methods: {
    ////////////////////////////////////////////////////////////////////////////////////////// 高評価・低評価

    // ▼history
    //   問題詳細から呼ばれたときは history_records がないので history だけを更新する
    //
    // ▼vote_key
    //   good or bad
    //
    // ▼enabled
    //   enabled: enabled → その値に設定
    //   enabled: null       → トグルする
    vote_handle(history, vote_key, enabled) {
      if (this.login_required_warning_notice()) { return }

      if (this.current_user) {
        if (history.question.user.id === this.current_user.id) {
          this.warning_notice("自分が投稿した問題です")
          return
        }
      }

      this.sound_play_click()

      const params = {
        question_id: history.question.id,
        vote_key: vote_key,
        enabled: null,
      }

      this.silent_api_put("vote_handle", params, e => {
        this.vote_talk(e)

        // 該当のレコードを更新
        this.vote_set(history, e)

        // さらに「履歴」と「保存リスト」のなかに同じ問題があれば状態を更新する
        this.history_and_clip_records.forEach(history => {
          if (history.question.id === e.question_id) {
            this.vote_set(history, e)
          }
        })
      })
    },

    vote_set(history, e) {
      history.good_p                    = e.good.enabled
      history.question.good_marks_count = e.good.count

      history.bad_p                     = e.bad.enabled
      history.question.bad_marks_count  = e.bad.count
    },

    vote_talk(e) {
      if (e.good.diff >= 1) {
        this.say("よき")
      }
      if (e.bad.diff >= 1) {
        this.say("だめ")
      }
    },

    ////////////////////////////////////////////////////////////////////////////////////////// 保存

    clip_handle(history, enabled) {
      if (this.login_required_warning_notice()) { return }

      this.sound_play_click()

      const params = {
        question_id: history.question.id,
        enabled: null,
      }

      this.silent_api_put("clip_handle", params, e => {
        if (e.diff >= 1) {
          this.say("保存リストに追加しました")
        }

        // 該当のレコードを更新
        this.clip_set(history, e)

        // さらに「履歴」と「保存リスト」のなかに同じ問題があれば状態を更新する
        this.history_and_clip_records.forEach(history => {
          if (history.question.id === e.question_id) {
            this.clip_set(history, e)
           }
        })
      })
    },

    clip_set(history, e) {
      history.clip_p = e.clip.enabled
      history.question.clip_marks_count = e.clip.count
    },
  },

  computed: {
    history_and_clip_records() {
      return this.history_records.concat(this.clip_records)
    },
  },
}
