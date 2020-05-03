// 汎用コード

import Bowser from "bowser"
import qs from "qs"

import dayjs from "dayjs"
import "dayjs/locale/ja.js"
dayjs.locale('ja')

import SfenParser from "shogi-player/src/sfen_parser.js"

export default {
  methods: {
    defval(v, default_value) {
      if (v == null) {
        return default_value
      } else {
        return v
      }
    },

    rand(n) {
      return Math.floor(Math.random() * n)
    },

    float_to_perc(v, precision = 0) {
      return _.floor(v * 100, precision)
    },

    process_now() {
      this.$buefy.loading.open()
    },

    debug_alert(message) {
      if (this.development_p) {
        if (message) {
          this.$buefy.toast.open({message: message.toString(), position: "is-bottom", type: "is-danger", duration: 1000 * 1.0, queue: false})
        }
      }
    },

    debug_print(...args) {
      if (this.development_p) {
        console.log(...args)
      }
    },

    // #以降を除いた現在のパス
    // http://localhost:3000/xy?abc=1#1 ↓
    // http://localhost:3000/xy?abc=1
    location_url_without_hash() {
      return window.location.href.replace(window.location.hash, "")
    },

    // ?foo=1#xxx を除いた現在のパス
    // http://localhost:3000/xy?abc=1 ↓
    // http://localhost:3000/xy
    location_url_without_search_and_hash() {
      return this.location_url_without_hash().replace(window.location.search, "")
    },

    dayjs_format(time, format) {
      return dayjs(time).format(format)
    },

    // // 他のウィンドウで開く
    // url_open(url) {
    //   // this.process_now()
    //   if (window.open(url, "_self")) {
    //     // Google Chrome では動く
    //   } else {
    //     // iOS Safari ではこちら
    //     this.url_open(url)
    //   }
    // },

    // 他のウィンドウで開く
    url_open(url) {
      // this.process_now()
      location.href = url
    },

    // モバイルでないときだけ elem にフォーカスする
    // なぜか $nextTick ではフォーカスされない場合があるため setTimeout に変更
    desktop_focus_to(elem) {
      if (this.desktop_p) {
        this.focus_to(elem)
      }
    },

    // $nextTick ではフォーカスされない場合があるため setTimeout にしている
    // それでも 2msec だと効かない場合もあるため 0.1 秒待つようにしている
    focus_to(elem) {
      setTimeout(() => {
        if (elem) {
          elem.focus()
        }
      }, 1000 * 0.1)
    },

    // FIXME: URL() を使う
    legacy_url_build(attributes) {
      if (false) {
        return _.map(attributes, (v, k) => `${k}=${encodeURIComponent(v)}`).join("&")
      } else {
        return qs.stringify(attributes)
      }
    },

    // 通知
    simple_notify(message) {
      this.talk(message, {rate: 1.5})
      this.$buefy.toast.open({message: message, position: "is-bottom", type: "is-info", duration: 1000 * 1, queue: false})
    },

    tweet_intent_url(text) {
      if (text) {
        const url = new URL("https://twitter.com/intent/tweet")
        url.searchParams.set("text", text)
        return url.toString()
      }
    },

    // Twitterアプリ内ブラウザからTwitterアプリに遷移しなくなるので別ウィンドウで開いてはいけない
    tweet_share_open(params) {
      const url = new URL("https://twitter.com/intent/tweet")
      // const url = new URL("https://twitter.com/share")
      _.each(params, (v, k) => {
        if (v) {
          url.searchParams.set(k, v)
        }
      })
      this.url_open(url.toString())
    },

    popup_open(url) {
      alert("使用禁止")

      const width = 575
      const height = 256
      const left = (window.screen.width - width) / 2
      const top = (window.screen.height - height) / 2
      const opts = `status=no,top=${top},left=${left},width=${width},height=${height}`
      window.open(url, "_blank", opts)
    },

    piyo_shogi_full_url(path, turn, flip) {
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

    kento_full_url(sfen, turn, flip) {
      if (!sfen) {
        alert("sfenが空")
      }
      const info = SfenParser.parse(sfen)
      const url = new URL("https://www.kento-shogi.com")
      url.searchParams.set("initpos", info.init_sfen_strip)
      if (info.attributes.moves) {
        url.searchParams.set("moves", info.attributes.moves.replace(/\s+/g, "."))
      }
      url.searchParams.set("flip", flip)
      url.hash = turn
      return url.toString()
    },

    as_full_url(path) {
      if (path.match(/^http/)) {
        return path
      } else {
        return window.location.origin + path
      }
    },

    assert_path(path) {
      if (path.match(/^http/)) {
        alert(`すでにフルURL化されている : ${path}`)
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    row_time_format(t) {
      const date = dayjs(t)
      const diff_day = dayjs().diff(date, "day")
      const diff_year = dayjs().diff(date, "year")
      if (diff_day < 1) {
        return date.format("HH:mm")
      }
      if (diff_year < 1) {
        return date.format("M/D HH:mm")
      }
      return date.format("YYYY-MM-DD")
    },

    date_to_custom_format(t) {
      return dayjs(t).format(this.md_or_yyyymmdd_format(t))
    },

    md_or_yyyymmdd_format(t) {
      const date = dayjs(t)
      if (date.year() === dayjs().year()) {
        return "M / D"
      } else {
        return "YYYY-MM-DD"
      }
    },

    date_to_ymd(t) {
      return dayjs(t).format("YYYY-MM-DD")
    },

    date_to_wday(t) {
      return dayjs(t).format("ddd")
    },
  },

  computed: {
    development_p() {
      return process.env.NODE_ENV === "development"
    },

    mobile_p() {
      const html_el = document.querySelector("html")
      return html_el.classList.contains("mobile")
    },

    desktop_p() {
      return !this.mobile_p
    },

    url_prefix() {
      if (this.development_p) {
        return ""
      } else {
        return ""
        // return "/shogi"
      }
    },

    RAILS_ENV() {
      return window.RAILS_ENV
    },

    // https://www.npmjs.com/package/bowser
    user_agent_hash() {
      // 古い Edge
      // return Bowser.parse("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36 Edge/18.18362")
      // browser: {name: "Microsoft Edge", version: "18.18362"}
      // os: {name: "Windows", version: "NT 10.0", versionName: "10"}
      // platform: {type: "desktop"}
      // engine: {name: "EdgeHTML", version: "18.18362"}

      // 新しい Edge
      // return Bowser.parse("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.130 Safari/537.36 Edg/79.0.309.71")
      // browser: {name: "Microsoft Edge", version: "79.0.309.71"}
      // os: {name: "Windows", version: "NT 10.0", versionName: "10"}
      // platform: {type: "desktop"}
      // engine: {name: "Blink"}

      console.log(window.navigator.userAgent)
      return Bowser.parse(window.navigator.userAgent)
    },
  },
}
