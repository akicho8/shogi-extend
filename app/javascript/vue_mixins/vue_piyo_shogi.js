// https://www.studiok-i.net/kifu/?sfen=position%20sfen%20lnsgkgsnl%2F1r5b1%2Fp1pppp1pp%2F1p4p2%2F9%2F2P4P1%2FPP1PPPP1P%2F1B5R1%2FLNSGKGSNL%20b%20-%201&game_name=&sente_name
// https://www.studiok-i.net/ps/?sfen=position%20sfen%20lnsgkgsnl%2F1r5b1%2Fp1pppp1pp%2F1p4p2%2F9%2F2P4P1%2FPP1PPPP1P%2F1B5R1%2FLNSGKGSNL%20b%20-%201

export default {
  methods: {
    piyo_shogi_full_url(sfen, turn, flip) {
      let prefix = null
      if (this.piyo_shogi_app_p) {
        prefix = "piyoshogi://"
      } else {
        prefix = "https://www.studiok-i.net/ps/"
      }
      return `${prefix}?num=${turn}&flip=${flip}&sfen=${encodeURIComponent(sfen)}`
    },
  },
  computed: {
    // アプリ版「ぴよ将棋」が起動できるか？
    piyo_shogi_app_p() {
      return this.isMobile.iOS() || this.isMobile.Android()
    },
  },
}
