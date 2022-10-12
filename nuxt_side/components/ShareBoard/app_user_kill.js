export const app_user_kill = {
  methods: {
    // user_kill("bob") で bob を退室させる
    user_kill(killed_user_name) {
      const params = {
        killed_user_name: killed_user_name,
      }
      this.ac_room_perform("user_kill", params) // --> app/channels/share_board/room_channel.rb
    },
    user_kill_broadcasted(params) {
      if (params.killed_user_name === this.user_name) {
        this.room_destroy()
      }
    },
  },
}
