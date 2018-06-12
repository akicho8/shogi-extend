document.addEventListener("DOMContentLoaded", () => {
  App.user_show_vm = new Vue({
    el: "#user_show_app",
    data() {
      return {
        battle_rooms: js_user_profile.battle_rooms,
      }
    },

    created() {
    },

    methods: {
      memberships_format(battle_room) {
        return battle_room.memberships.map(e => {
          return `<img class="avatar_image" src="${e.user.avatar_url}" />${e.user.name}`
        }).join(" ")
      },

      kattakadouka(battle_room) {
        let str = null
        if (_.isNil(battle_room.win_location_key)) {
          return "未決着"
        }
        let list = _.filter(battle_room.memberships, e => (e.user.id == js_user_profile.id))
        list = _.uniqBy(list, e => e.location_key)
        if (list.length > 1) {
          str = "自己対局"
        } else {
          if (_.first(list).location_key == battle_room.win_location_key) {
            str = "勝ち"
          } else {
            str = "負け"
          }
        }
        return str
      },
    },

    computed: {
    },
  })
})
