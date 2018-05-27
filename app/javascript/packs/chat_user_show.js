document.addEventListener("DOMContentLoaded", () => {
  App.chat_user_show_vm = new Vue({
    el: "#chat_user_show_app",
    data() {
      return {
        chat_rooms: chat_user_show_app_params.chat_rooms,
      }
    },

    created() {
    },

    methods: {
      room_members_format(chat_room) {
        return chat_room.chat_memberships.map(e => e.chat_user.name).join(" vs ")
      },

    },

    computed: {
    },
  })
})
