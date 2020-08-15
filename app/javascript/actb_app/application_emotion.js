export const application_emotion = {
  methods: {
    emotion_handle(params) {
      this.ac_room_perform("emotion_handle", params) // --> app/channels/actb/room_channel.rb
    },
    emotion_handle_broadcasted(params) {
      if (params.membership_id === this.room_my_membership.id) {
        this.debug_alert("自分")
      } else {
        this.debug_alert("相手")
      }
      if (params.message || params.say) {
        this.sound_play("spon")
        if (params.message) {
          this.$buefy.toast.open({
            message: params.message,
            position: params.position || "is-top",
            queue: false,
            type: params.type,
            duration: params.duration || 1000 * 2,
          })
        }
        if (params.say) {
          this.say(params.say)
        }
      }
    },
  },
}
