// 汎用コード

import Bowser from "bowser"
import dayjs from "dayjs"
import qs from "qs"

export default {
  methods: {
    rand(n) {
      return Math.floor(Math.random() * n)
    },

    number_to_percentage2(v, precision = 0) {
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
      const html_el = document.querySelector("html")
      if (!html_el.classList.contains("mobile")) {
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

    tweet_url_for(text) {
      if (text) {
        return `https://twitter.com/intent/tweet?text=${encodeURIComponent(text)}`
      }
    },
  },

  computed: {
    development_p() {
      return process.env.NODE_ENV === "development"
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
