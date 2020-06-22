// https://www.studiok-i.net/kifu/?sfen=position%20sfen%20lnsgkgsnl%2F1r5b1%2Fp1pppp1pp%2F1p4p2%2F9%2F2P4P1%2FPP1PPPP1P%2F1B5R1%2FLNSGKGSNL%20b%20-%201&game_name=&sente_name
// https://www.studiok-i.net/ps/?sfen=position%20sfen%20lnsgkgsnl%2F1r5b1%2Fp1pppp1pp%2F1p4p2%2F9%2F2P4P1%2FPP1PPPP1P%2F1B5R1%2FLNSGKGSNL%20b%20-%201

export default {
  methods: {
    piyo_shogi_full_url(attributes) {
      const keys = ["sfen", "num", "flip", "sente_name", "gote_name", "game_name"]
      const url_params = []

      keys.forEach(e => {
        const v = attributes[e]
        if (v != null) {
          url_params.push([e, encodeURIComponent(v)].join("="))
        }
      })
      return [this.piyo_shogi_url_prefix, "?", url_params.join("&")].join("")
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
