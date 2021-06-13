export const app_chore = {
  data() {
    return {
    }
  },
  methods: {
    place_talk(place) {
      const x = DIMENSION - place.x
      const y = place.y + 1
      this.talk(`${x} ${y}`, {rate: 2.0})
    },

    // 最後に押したところに色をつける
    sp_board_piece_back_user_class(place) {
      if (this.tap_method_p) {
        if (this.mode === "is_mode_run") {
          if (this.tapped_place) {
            if (this.xy_equal_p(this.tapped_place, place)) {
              return "has-background-primary-light"
            }
          }
        }
      }
    },
  },
  computed: {
  },
}
