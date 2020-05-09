import Vuex from 'vuex'

export default {
  mixins: [
  ],
  components: {
  },
  data() {
    return {
    }
  },
  created() {
  },
  watch: {
  },
  methods: {
    warning_dialog(message) {
      this.$buefy.dialog.alert({
        title: "ERROR",
        message: message,
        canCancel: ["outside", "escape"],
        type: "is-danger",
        hasIcon: true,
        icon: "times-circle",
        iconPack: "fa",
        trapFocus: true,
      })
    },

    ok_notice(message) {
      this.$buefy.toast.open({message: message, position: "is-bottom", type: "is-success", queue: false})
      this.talk(message, {rate: 1.5})
    },

    warning_notice(message) {
      this.sound_play("x")
      this.$buefy.toast.open({message: message, position: "is-bottom", type: "is-warning", queue: false})
      this.talk(message, {rate: 1.5})
    },

    position_sfen_remove(sfen) {
      return sfen.replace(/position sfen\s+/, "")
    },
  },
  computed: {
    ...Vuex.mapGetters([
      'current_gvar1',
    ]),
    // ...mapState([
    //   'fooKey',
    // ]),
  },
}
