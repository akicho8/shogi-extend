// 汎用コード

import Bowser from "bowser"
import qs from "qs"

import dayjs from "dayjs"
import "dayjs/locale/ja.js"
dayjs.locale('ja')

export default {
  methods: {
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

    // 他のウィンドウで開く
    other_window_open(url) {
      // this.process_now()
      if (window.open(url, "_self")) {
        // Google Chrome では動く
      } else {
        // iOS Safari ではこちら
        this.self_window_open(url)
      }
    },

    // 他のウィンドウで開く
    self_window_open(url) {
      // this.process_now()
      location.href = url
    },

    // モバイルでないときだけ elem にフォーカスする
    desktop_only_focus(elem) {
      if (this.desktop_p) {
        if (elem) {
          elem.focus()
        }
      }
    },

    url_build(attributes) {
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
        return `https://twitter.com/intent/tweet?text=${encodeURIComponent(text)}`
      }
    },

    piyo_shogi_full_url(record, turn, flip) {
      const url = this.as_full_url(record.show_path) + ".kif"
      return `piyoshogi://?num=${turn}&url=${url}` // TODO: flip つけたい
    },

    kento_full_url(record, turn, flip) {
      const full = "https://www.kento-shogi.com" + record.kento_app_path
      const url = new URL(full)
      url.hash = turn
      return url.toString()
    },

    as_full_url(path) {
      if (path) {
        this.assert_path(path)
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
