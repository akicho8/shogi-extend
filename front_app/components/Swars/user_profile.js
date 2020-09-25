document.addEventListener("DOMContentLoaded", () => {
  App.user_show_vm = new Vue({
    el: "#user_show_app",

    data() {
      return {
        battles: js_user_profile.battles,
      }
    },

    methods: {
      memberships_format(battle) {
        return battle.memberships.map(e => {
          return `<img class="avatar_image" src="${e.user.avatar_path}" />${e.user.name}`
        }).join(" ")
      },

      winning_or_losing_format(battle) {
        let str = null
        if (_.isNil(battle.win_location_key)) {
          return "未決着"
        }
        let list = _.filter(battle.memberships, e => (e.user.id === js_user_profile.id))
        list = _.uniqBy(list, e => e.location_key)
        if (list.length > 1) {
          str = "自己対局"
        } else {
          if (_.first(list).location_key == battle.win_location_key) {
            str = "勝ち"
          } else {
            str = "負け"
          }
        }
        return str
      },
    },
  })
})
