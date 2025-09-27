import _ from "lodash"

export const mod_table = {
  methods: {
    sort_handle(sort_column, sort_order) {
      this.sfx_play_click()

      if (false) {
        this.book.xitems = _.orderBy(this.book.xitems, sort_column, sort_order)
      } else {
        let a = this.book.xitems.filter(e => e.answer_stat.spent_sec_total != null)
        let b = this.book.xitems.filter(e => e.answer_stat.spent_sec_total == null)
        a = _.orderBy(a, sort_column, sort_order)
        b = _.orderBy(b, sort_column, sort_order)
        this.book.xitems = [...a, ...b]
      }

      this.op_index_set_all()
      this.current_index = 0
    },
  },
}
