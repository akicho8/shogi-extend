export const mod_user_kick = {
  methods: {
    // user_kick("bob") で bob を退室させる
    user_kick(kicked_user_name) {
      const params = {
        kicked_user_name: kicked_user_name,
      }
      this.ac_room_perform("user_kick", params) // --> app/channels/share_board/room_channel.rb
    },
    user_kick_broadcasted(params) {
      if (params.kicked_user_name === this.user_name) {
        this.room_destroy()
      }
    },
  },
}
