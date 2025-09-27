export const mod_answer = {
  data() {
    return {
      answer_tab_index:   null, // 表示している正解タブの位置
      // answer_turn_offset: null, // 正解モードでの手数
    }
  },

  methods: {
    // 正解だけを削除
    answers_clear() {
      this.$set(this.article, "moves_answers", [])
      this.answer_tab_index = 0
    },

    // 「この手順を正解とする」
    answer_create_handle() {
      this.sfx_click()
      this.answer_create(this.current_moves())
    },

    answer_create(moves) {
      if (moves.length === 0) {
        this.toast_warn("1手以上動かしてください")
        return
      }

      // {
      //   const limit = this.config.turm_max_limit
      //   if (limit && moves.length > limit) {
      //     this.toast_warn(`${this.config.turm_max_limit}手以内にしてください`)
      //     return
      //   }
      // }

      if (this.article.moves_valid_p(moves)) {
        this.toast_warn("すでに同じ正解があります")
        return
      }

      this.article.moves_answers.push({moves: moves})
      this.$nextTick(() => this.answer_tab_index = this.article.moves_answers.length - 1)

      this.toast_ok(`${this.article.moves_answers.length}つ目の正解を追加しました`, {onend: () => {
        if (this.article.moves_answers.length === 1) {
          this.toast_ok(`他の手順で正解がある場合は続けて追加してください`)
        }
      }})
    },

    answer_delete_at(index) {
      const new_ary = this.article.moves_answers.filter((e, i) => i !== index)
      this.$set(this.article, "moves_answers", new_ary)
      this.$nextTick(() => this.answer_tab_index = _.clamp(this.answer_tab_index, 0, this.article.moves_answers.length - 1))

      this.sfx_click()
      this.toast_ok("削除しました")
    },
  },
}
