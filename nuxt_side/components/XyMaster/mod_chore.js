const IOS15_ALERT = false

export const mod_chore = {
  mounted() {
    if (IOS15_ALERT) {
      if (this.ios15_p) {
        this.ios15_dialog_alert()
      }
    }
  },

  methods: {
    place_talk(place) {
      const x = this.DIMENSION - place.x
      const y = place.y + 1
      this.talk(`${x} ${y}`, {rate: 2.0})
    },

    // 最後に押したところに色をつける
    sp_board_cell_class_fn(place) {
      if (this.tap_mode_p) {
        if (this.mode === "is_mode_run") {
          if (this.tapped_place) {
            if (this.xy_equal_p(this.tapped_place, place)) {
              return "is_tapped_cell"
            }
          }
        }
      }
    },

    ios15_dialog_alert() {
      this.dialog_alert({
        hasIcon: true,
        type: "is-warning",
        title: "悲報",
        message: "お使いの iPhone (iOS15) では連打できなくなってしまいました。すばやく2連続で正解しても2回目が無視されます。<br><br>- 続報 -<br>いったんブラウザのタブをすべて閉じて開き直したりするとまれに直ったりします。",
      })
    },
  },

  computed: {
    ios15_p() { return window.navigator.userAgent.match(/iPhone OS 15_/) },
  },
}
