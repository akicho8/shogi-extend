// 汎用コード

import Bowser from "bowser"
import qs from "qs"

import SfenParser from "shogi-player/src/sfen_parser"

const strip_tags = require('striptags')

import { isMobile } from "../components/models/isMobile.js"

import Autolinker from 'autolinker'

export default {
  data() {
    return {
      call_logs: [],
    }
  },

  methods: {
    // ../../../node_modules/autolinker/README.md
    auto_link(str, options = {}) {
      return Autolinker.link(str, {newWindow: true, truncate: 30, mention: "twitter", ...options})
    },

    // string_truncate("hello", {length: 20})
    string_truncate(str, options = {}) {
      return _.truncate(str, {omission: "...", length: 80, ...options})
    },

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

    // 0.1234 -> 12.34
    float_to_perc2(v) {
      const base = 100
      return Math.floor(v * 100 * base) / base
    },

    number_floor(v, precision = 0) {
      return _.floor(v, precision)
    },

    process_now() {
      this.$buefy.loading.open()
    },

    debug_alert(message) {
      if (this.development_p) {
        if (message != null) {
          this.$buefy.toast.open({message: message.toString(), position: "is-bottom", type: "is-danger", duration: 1000 * 1.0, queue: false})
        }
      }
    },

    clog(...args) {
      if (this.development_p) {
        console.log(...args)
      }
    },

    call_log(key) {
      let mark = ""
      if (process.server) {
        mark = "server"
      } else {
        mark = "client"
      }
      const log = `●[fetch][${key}] ${mark}`
      this.call_logs.push(log)
      this.clog(log)
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

    // URLを開く
    // url_open(url, this.target_default) で呼ぶとPCの場合はWindowを開く
    url_open(url, target = null) {
      if (target === "_blank") {
        return window.open(url, "_blank")
      }

      // this.process_now()
      location.href = url
    },

    sp_turn_slider_auto_focus() {
      this.desktop_focus_to(this.$el.querySelector(".turn_slider"))
    },

    // モバイルでないときだけ elem にフォーカスする
    // なぜか $nextTick ではフォーカスされない場合があるため setTimeout に変更
    desktop_focus_to(elem) {
      if (!isMobile.any()) {
        this.focus_to(elem)
      }
    },

    // $nextTick ではフォーカスされない場合があるため setTimeout にしている
    // それでも 2msec だと効かない場合もあるため 0.1 秒待つようにしている
    // が、1 でも効いた。
    focus_to(elem) {
      if (elem) {
        setTimeout(() => elem.focus(), 1)
      }
    },

    legacy_url_build(url, params) {
      const obj = new URL(this.as_full_url(url)) // URL には http から始まるURLしか渡せないので取ってはいけない
      _.each(params, (v, k) => obj.searchParams.set(k, v))
      return obj.toString()
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

    tweet_share_open(params) {
      const url = new URL("https://twitter.com/intent/tweet")
      // const url = new URL("https://twitter.com/share")
      _.each(params, (v, k) => {
        if (v) {
          url.searchParams.set(k, v)
        }
      })
      this.popup_open(url.toString())
    },

    popup_open(url) {
      const width = 800
      const height = 640
      const left = (window.screen.width - width) / 2
      const top = (window.screen.height - height) / 2
      const opts = `status=no,top=${top},left=${left},width=${width},height=${height}`
      window.open(url, "_blank", opts)
    },

    kento_full_url({sfen, turn, flip}) {
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

    __assert__(value, message = null) {
      if (!value) {
        alert(message || "assert error")
        debugger
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    // body ではなく html を対象にしないと隙間が見えてしまう
    html_background_color_set(color = "") {
      const elem = document.querySelector("html")
      elem.style.backgroundColor = color
    },

    // 一番下までスクロール
    scroll_to_bottom(elem) {
      if (elem) {
        this.$nextTick(() => elem.scrollTop = elem.scrollHeight)
      }
    },

    // scroll_to_bottom2(elem) {
    //   if (this.$refs[elem]) {
    //     this.$nextTick(() => {
    //       this.$refs[elem].scrollTop = this.$refs[elem].scrollHeight
    //     })
    //   }
    // },

    simple_format(str) {
      return str.replace(/\n/g, "<br>")
    },

    // sfen_parser.moves.length
    sfen_parse(sfen) {
      return SfenParser.parse(sfen)
    },

    // strip_tags(html)
    // strip_tags(html, '<strong>')
    // strip_tags(html, ['a'])
    // strip_tags(html, [], '\n')
    strip_tags(...args) {
      return strip_tags(...args)
    },
  },

  computed: {
    // スマホなら _self の方が使いやすい
    // PCなら _blank の方が使いやすい
    target_default() {
      return isMobile.any() ? "_self" : "_blank"
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
