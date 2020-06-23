// https://www.studiok-i.net/kifu/?sfen=position%20sfen%20lnsgkgsnl%2F1r5b1%2Fp1pppp1pp%2F1p4p2%2F9%2F2P4P1%2FPP1PPPP1P%2F1B5R1%2FLNSGKGSNL%20b%20-%201&game_name=&sente_name
// https://www.studiok-i.net/ps/?sfen=position%20sfen%20lnsgkgsnl%2F1r5b1%2Fp1pppp1pp%2F1p4p2%2F9%2F2P4P1%2FPP1PPPP1P%2F1B5R1%2FLNSGKGSNL%20b%20-%201

export default {
  methods: {
    piyo_shogi_full_url(params) {
      const keys = ["sfen", "num", "flip", "sente_name", "gote_name", "game_name"]
      const values = []

      keys.forEach(e => {
        const v = params[e]
        if (v != null) {
          values.push([e, encodeURIComponent(v)].join("="))
        }
      })
      return [this.piyo_shogi_url_prefix, "?", values.join("&")].join("")
    },

    piyo_shogi_name_params(record) {
      const params = {}
      if (record.memberships) {
        params.sente_name = this.ps_user_with_grade_name(record.memberships, "black")
        params.gote_name  = this.ps_user_with_grade_name(record.memberships, "white")
      }
      if (record.tournament_name) {
        params.game_name = record.tournament_name
      }
      return params
    },

    ps_user_with_grade_name(memberships, location_key) {
      const membership = memberships.find(e => e.location.key === location_key)
      return `${membership.user.key} ${membership.grade_info.name}`
    },
  },

  computed: {
    // アプリ版「ぴよ将棋」が起動できるか？
    piyo_shogi_app_p() {
      return this.isMobile.iOS() || this.isMobile.Android()
    },

    piyo_shogi_url_prefix() {
      if (this.piyo_shogi_app_p) {
        return "piyoshogi://"
      } else {
        return "https://www.studiok-i.net/ps/"
      }
    },

    piyo_shogi_url_keys() {
      return ["turn", "flip", "sente_name", "gote_name", "game_name", "sfen"]
    },
  },
}
