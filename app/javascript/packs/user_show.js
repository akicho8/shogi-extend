document.addEventListener("DOMContentLoaded", () => {
  App.user_show_vm = new Vue({
    el: "#user_show_app",
    data() {
      return {
        chat_rooms: user_show_app_params.chat_rooms,
      }
    },

    created() {
    },

    methods: {
      room_members_format(chat_room) {
        return chat_room.memberships.map(e => e.user.name).join(" vs ")
      },

    },

    computed: {
    },
  })
})
