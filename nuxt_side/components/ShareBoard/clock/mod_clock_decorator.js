export const mod_clock_decorator = {
  methods: {
    // private

    // shogi-player に渡す名前
    sp_player_name_for(location) {
      if (location.key === this.current_location.key) {
        return this.current_turn_user_name
      } else {
        return this.next_turn_user_name
      }
    },

    // shogi-player に渡す時間のHTMLを作る
    cc_player_info(location) {
      if (this.clock_box == null) {
        return {}
      }

      const e = this.clock_box.single_clocks[location.code]
      let o = []
      if (e.initial_main_sec >= 1 || e.every_plus >= 1) {
        o.push(`<div class="second main_sec">${e.main_sec_mmss}</div>`)
      }
      if (e.initial_read_sec >= 1) {
        o.push(`<div class="second read_sec">${e.read_sec_mmss}</div>`)
      }
      if (e.initial_extra_sec >= 1) {
        o.push(`<div class="second extra_sec">${e.extra_sec_mmss}</div>`)
      }
      const values = o.join("")

      const container_class = [...e.dom_class]
      if (e.main_sec === 0) {
        if (e.initial_read_sec >= 1) {
          if (e.read_sec >= 1) {
            if (e.read_sec <= 10) {
              container_class.push("read_sec_10")
            } else if (e.read_sec <= 20) {
              container_class.push("read_sec_20")
            } else {
              container_class.push("read_sec_60")
            }
          }
        }
        if (e.read_sec === 0) {
          if (e.initial_extra_sec >= 1) {
            if (e.extra_sec >= 1) {
              if (e.extra_sec <= 10) {
                container_class.push("extra_sec_10")
              } else if (e.extra_sec <= 20) {
                container_class.push("extra_sec_20")
              } else {
                container_class.push("extra_sec_60")
              }
            }
          }
        }
      }
      return {
        time: values,
        class: container_class,
      }
    },
  },
  computed: {
    // return {
    //   black: { name: "先手", time: this.clock_box.single_clocks[0].main_sec_mmss },
    //   white: { name: "後手", time: this.clock_box.single_clocks[1].main_sec_mmss },
    // }
    sp_player_info() {
      return this.Location.values.reduce((a, e) => {
        return {
          ...a,
          [e.key]: {
            name: this.sp_player_name_for(e),
            ...this.cc_player_info(e),
          },
        }
      }, {})
    },
  },
}
