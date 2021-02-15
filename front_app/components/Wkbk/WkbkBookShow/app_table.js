import _ from "lodash"

export const app_table = {
  methods: {
    sort_handle(sort_column, sort_order) {
      this.sound_play("click")
      this.book.xitems = _.orderBy(this.book.xitems, sort_column, sort_order)
      this.op_index_set_all()
      this.current_index = 0
    },
  },
}
