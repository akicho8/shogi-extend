import _ from "lodash"
import dayjs from "dayjs"
import MainSettingModal from "./MainSettingModal.vue"

export const app_main_setting = {
  data() {
    return {
      ctrl_mode: null,   // 対局時計が動作しているとき盤面下のコントローラーの表示有無
      debug_mode: null,  // デバッグモード (bool型にしてはいけない)
      yomiage_mode: null, // 検討時の読み上げの有無
    }
  },
  created() {
    this.ctrl_mode = this.development_p ? "is_ctrl_mode_visible" : "is_ctrl_mode_hidden"
    this.debug_mode = this.development_p ? "is_debug_mode_on" : "is_debug_mode_off"
    this.yomiage_mode = "is_yomiage_mode_on"
  },

  methods: {
    // for autoexec
    is_debug_mode_on() {
      this.debug_mode = "is_debug_mode_on"
    },

    general_setting_modal() {
      this.sidebar_p = false
      this.sound_play("click")

      this.$buefy.modal.open({
        component: MainSettingModal,
        parent: this,
        trapFocus: true,
        hasModalCard: true,
        animation: "",
        canCancel: true,
        onCancel: () => {
          this.sound_play("click")
        },
        props: {
          base: this.base,
        },
      })
    },

    // ////////////////////////////////////////////////////////////////////////////////
    //
    // message_share(params) {
    //   this.ac_room_perform("message_share", params) // --> app/channels/share_board/room_channel.rb
    // },
    // message_share_broadcasted(params) {
    //   if (params.message) {
    //     this.$buefy.toast.open({
    //       container: ".BoardWood",
    //       message: `${params.from_user_name}: ${params.message}`,
    //       position: "is-top",
    //       type: "is-white",
    //       queue: false,
    //     })
    //     this.talk(params.message)
    //     this.ml_add(params)
    //   }
    // },
  },
  computed: {
    debug_mode_p() {
      return this.debug_mode === "is_debug_mode_on"
    },
  },
}
