import Vuex from 'vuex'

const POSITION_SFEN_PREFIX = "position sfen "

export const support = {
  methods: {
    warning_dialog(room_message) {
      this.$buefy.dialog.alert({
        title: "ERROR",
        room_message: room_message,
        canCancel: ["outside", "escape"],
        type: "is-danger",
        hasIcon: true,
        icon: "times-circle",
        iconPack: "fa",
        trapFocus: true,
      })
    },

    ok_notice(room_message) {
      this.$buefy.toast.open({message: room_message, position: "is-bottom", type: "is-success", queue: false})
      this.talk(room_message, {rate: 1.5})
    },

    warning_notice(room_message) {
      this.sound_play("x")
      this.$buefy.toast.open({message: room_message, position: "is-bottom", type: "is-warning", queue: false})
      this.talk(room_message, {rate: 1.5})
    },

    position_sfen_remove(sfen) {
      this.__assert(sfen != null, "sfen != null")
      return sfen.replace(POSITION_SFEN_PREFIX, "")
    },

    position_sfen_add(sfen) {
      this.__assert(sfen != null, "sfen != null")
      return POSITION_SFEN_PREFIX + sfen
    },

    main_nav_set(display_p) {
      return

      const el = document.querySelector("#main_nav")
      if (el) {
        if (display_p) {
          el.classList.remove("is-hidden")
        } else {
          el.classList.add("is-hidden")
        }
      }
    },

    delay(seconds, block) {
      setTimeout(block, 1000 * seconds)
    },

    // { xxx: true, yyy: false } 形式に変換
    as_visible_hash(v) {
      return _.reduce(v, (a, e) => ({...a, [e.key]: e.visible}), {})
    },
  },
  computed: {
    ...Vuex.mapState([
      'app',
    ]),
    ...Vuex.mapGetters([
      'current_gvar1',
    ]),
    // ...mapState([
    //   'fooKey',
    // ]),
  },
}
