import _ from "lodash"

export const mod_op = {
  methods: {
    // 不正解のみ残す
    op_select_x_handle() {
      this.sfx_click()
      if (this.jo_counts.mistake >= 1 && this.jo_counts.correct === 0 && this.jo_counts.blank === 0) {
        this.toast_warn("すでに不正解だけです")
        return
      }
      if (this.jo_counts.mistake === 0) {
        this.toast_warn("不正解が見つかりません")
        return
      }
      this.book.xitems = this.book.xitems.filter(e => {
        const answer_kind_info = this.journal_answer_kind_info_for(e)
        if (answer_kind_info) {
          return answer_kind_info.key === "mistake"
        }
      })
      this.op_index_set_all()
      this.current_index = 0
      this.toast_ok("不正解だけにしました")
    },

    // 元に戻す
    op_revert_handle() {
      // this.sfx_click()
      // if (this.book.xitems.length === this.saved_xitems.length) {
      //   this.toast_warn("すでに元の状態です")
      //   return
      // }
      // this.book.xitems = _.cloneDeep(this.saved_xitems)
      // this.current_index = 0
      // this.toast_ok("元に戻しました")
    },

    op_shuffle_handle() {
      this.sfx_click()
      if (this.book.xitems.length <= 1) {
        this.toast_warn("シャッフルするほどの問題がありません")
        return
      }

      if (false) {
        this.book.xitems = _.shuffle(this.book.xitems)
      } else {
        let a = this.book.xitems.filter(e => e.answer_stat.spent_sec_total != null)
        let b = this.book.xitems.filter(e => e.answer_stat.spent_sec_total == null)
        a = _.shuffle(a)
        b = _.shuffle(b)
        this.book.xitems = [...a, ...b]
      }

      this.op_index_set_all()
      this.current_index = 0
      this.toast_ok("シャッフルしました")

      this.$refs.WkbkBookShowTop.$refs.WkbkBookShowTopXitemTable.$refs.WkbkBookShowTopXitemTableBtable.resetMultiSorting()
      this.debug_alert("resetMultiSorting")
    },

    // いまいちな感じだけど b-table で扱いやすいように index を埋める
    op_index_set_all() {
      this.book.xitems.forEach((e, i) => e.index = i)
    },
  },
}
