document.addEventListener("DOMContentLoaded", () => {
  App.user_show_vm = new Vue({
    el: "#user_show_app",
    data() {
      return {
        battle_rooms: user_show_app_params.battle_rooms,
      }
    },

    created() {
    },

    methods: {
      room_members_format(battle_room) {
        return battle_room.memberships.map(e => e.user.name).join(" vs ")
      },

    },

    computed: {
    },
  })
})
