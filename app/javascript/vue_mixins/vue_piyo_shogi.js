// https://www.studiok-i.net/kifu/?sfen=position%20sfen%20lnsgkgsnl%2F1r5b1%2Fp1pppp1pp%2F1p4p2%2F9%2F2P4P1%2FPP1PPPP1P%2F1B5R1%2FLNSGKGSNL%20b%20-%201&game_name=&sente_name
// https://www.studiok-i.net/ps/?sfen=position%20sfen%20lnsgkgsnl%2F1r5b1%2Fp1pppp1pp%2F1p4p2%2F9%2F2P4P1%2FPP1PPPP1P%2F1B5R1%2FLNSGKGSNL%20b%20-%201

export default {
  methods: {
    legacy_piyo_shogi_full_url(path, turn, flip) {
      const url = this.as_full_url(path)

      // ".kif" を足す方法は悪手。パスが "/xxx" で終わっているとは限らない
      const url2 = new URL(url)

      if (false) {
        // ぴよ将棋はコンテンツを見ているのではなく .kif という拡張子を見ているのでこの方法は使えない
        // xxx?a=1&format=kif
        url2.searchParams.set("format", "kif")
      } else {
        // xxx.kif 形式
        url2.pathname = url2.pathname + ".kif"
      }

      const url3 = url2.toString()
      console.log(url3)

      // エスケープすると動かない
      const url4 = `piyoshogi://?num=${turn}&flip=${flip}&url=${url3}`

      console.log(url4)

      return url4
    },

    new_piyo_shogi_full_url(sfen, turn, flip) {
      let prefix = null
      if (this.piyo_shogi_app_p) {
        prefix = "piyoshogi://"
      } else {
        prefix = "https://www.studiok-i.net/ps/"
      }
      return `${prefix}?num=${turn}&flip=${flip}&sfen=${encodeURIComponent(sfen)}&game_name=a`
    },
  },
  computed: {
    // アプリ版「ぴよ将棋」が起動できるか？
    piyo_shogi_app_p() {
      return this.isMobile.iOS() || this.isMobile.Android()
    },
  },
}
