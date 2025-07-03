export const mod_chore = {
  methods: {
    // 最後に押したところに色をつける
    sp_board_cell_class_fn(place) {
      if (this.tapped_place) {
        if (this.xy_equal_p(this.tapped_place, place)) {
          return "is_tapped_cell"
        }
      }
    },
  },
}
