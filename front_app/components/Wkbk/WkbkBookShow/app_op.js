import _ from "lodash"

export const app_op = {
  methods: {
    // 不正解のみ残す
    op_select_x_handle() {
      this.sound_play("click")
      if (this.journal_ox_counts.x >= 1 && this.journal_ox_counts.o === 0 && this.journal_ox_counts.blank === 0) {
        this.toast_warn("すでに不正解だけです")
        return
      }
      if (this.journal_ox_counts.x === 0) {
        this.toast_warn("不正解が見つかりません")
        return
      }
      this.book.articles = this.book.articles.filter(e => {
        const ox_info = this.journal_ox_info_for(e)
        if (ox_info) {
          return ox_info.key === "x"
        }
      })
      this.op_index_set_all()
      this.current_index = 0
      this.toast_ok("不正解だけにしました")
    },

    // 元に戻す
    op_revert_handle() {
      this.sound_play("click")
      if (this.book.articles.length === this.saved_articles.length) {
        this.toast_warn("すでに元の状態です")
        return
      }
      this.book.articles = _.cloneDeep(this.saved_articles)
      this.current_index = 0
      this.toast_ok("元に戻しました")
    },

    op_shuffle_handle() {
      this.sound_play("click")
      this.book.articles = _.shuffle(this.book.articles)
      this.op_index_set_all()
      this.current_index = 0
      this.toast_ok("シャッフルしました")
    },

    // いまいちな感じだけど b-table で扱いやすいように index を埋める
    op_index_set_all() {
      this.book.articles.forEach((e, i) => e.index = i)
    },
  },
}
