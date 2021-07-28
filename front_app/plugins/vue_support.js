// 汎用コード

import { SfenParser } from "shogi-player/components/models/sfen_parser.js"

import twemoji from 'twemoji'

const strip_tags = require('striptags')

import { AnySupport } from "../components/models/any_support.js"
import { HandleNameParser } from "../components/models/handle_name_parser.js"

import Autolinker from 'autolinker'

import _ from "lodash"

export default {
  methods: {
    ...AnySupport,

    ua_icon_key_get() {
      if (typeof window === "undefined") {
        return "question"
      } else {
        const ua = window.navigator.userAgent.toLowerCase()
        if (this.mobile_p()) {
          if (ua.indexOf("android") >= 0) {
            return "android"
          } else if (ua.indexOf("ipad") >= 0 || (ua.indexOf("macintosh") >= 0 && "ontouchend" in document)) {
            return "tablet"
          } else {
            return "iphone"
          }
        } else {
          if (ua.indexOf("windows") >= 0) {
            return "windows"
          } else {
            return "desktop_computer"
          }
        }
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    // lodash の _.isEmpty は不自然な挙動なので使うべからず
    blank_p(value) {
      return value === undefined || value === null ||
        (typeof value === "object" && Object.keys(value).length === 0) ||
        (typeof value === "string" && value.trim().length === 0)
    },

    present_p(value) {
      return !this.blank_p(value)
    },

    presence(value) {
      if (this.blank_p(value)) {
        return null
      }
      return value
    },

    ////////////////////////////////////////////////////////////////////////////////

    // setTimeout のラッパーではない
    //
    // seconds < 0:  実行しない
    // seconds == 0: 即座に実行
    // seconds > 0:  seconds秒待って実行
    //
    delay_block(seconds, block) {
      if (seconds < 0) {
        return null
      }
      if (seconds === 0) {
        block()
        return null
      }
      return setTimeout(block, 1000 * seconds)
    },

    delay_stop(delay_id) {
      if (delay_id) {
        clearTimeout(delay_id)
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    // あとで実行する
    // だいたい 4ms 後に実行
    // これで他のイベントを先に動かせる
    callback_later(block) {
      return setTimeout(block, 0)
    },

    ////////////////////////////////////////////////////////////////////////////////

    ga_click(category) {
      if (this.$ga) {
        if (this.$config.STAGE !== "production") {
          category = `(${this.$config.STAGE}) ${category}`
        }
        if (this.development_p) {
          const message = `GA: ${category}`
          this.$buefy.toast.open({message: message, position: "is-top", type: "is-dark", queue: false})
          this.clog(message)
        }
        this.$ga.event(category, "click")
      }
    },

    // ../../../node_modules/autolinker/README.md
    // newWindow: true で target="_blank" になる
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
      return Math.trunc(v * 100 * base) / base
    },

    // 0.1234 -> 12
    float_to_integer_percentage(v) {
      return Math.trunc(v * 100)
    },

    number_floor(v, precision = 0) {
      return _.floor(v, precision)
    },

    // list 内のインデックス from の要素を to に移動
    // https://qiita.com/nowayoutbut/items/991515b32805e21f8892
    ary_move(list, from, to) {
      const n = list.length
      list = [...list]
      to = this.ruby_like_modulo(to, n)
      if (from === to || from > n - 1 || to > n - 1) {
        return list
      }
      const v = list[from]
      const tail = list.slice(from + 1)
      list.splice(from)
      Array.prototype.push.apply(list, tail)
      list.splice(to, 0, v)
      return list
    },

    // str_to_keywords("　,　a　,b,") // => ["a", "b"]
    // str_to_keywords(",")           // => []
    // str_to_keywords("")            // => []
    str_to_keywords(str) {
      str = str ?? ""
      str = str.replace(/\p{blank}+/g, " ") // 全角スペース → 半角スペース
      str = str.replace(/[\s,]+/g, " ")     // セパレータを半角スペースで統一
      str = _.trim(str)                     // 左右のスペースを除去
      if (str.length >= 1) {
        return _.uniq(str.split(/\s+/))
      } else {
        return []
      }
    },

    // keywords_str_toggle("a b", "c")   //=> "a b c"
    // keywords_str_toggle("a b c", "c") //=> "a b"
    keywords_str_toggle(keywords_str, str) {
      let keywords = this.str_to_keywords(keywords_str)
      if (keywords.includes(str)) {
        _.pull(keywords, str)
      } else {
        keywords.push(str)
      }
      return keywords.join(" ")
    },

    process_now() {
      this.$buefy.loading.open()
    },

    ////////////////////////////////////////////////////////////////////////////////

    debug_alert(...args) {
      if (this.development_p) {
        this.debug_alert_core(...args)
      }
    },

    debug_alert_core(message) {
      if (message != null) {
        this.$buefy.toast.open({
          message: message.toString(),
          position: "is-bottom",
          type: "is-danger",
          duration: 1000 * 2.5,
          queue: false,
        })
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    clog(...args) {
      if (this.development_p) {
        console.log(...args)
      }
    },

    // 1つ前に戻れるなら戻る
    // 戻れないならトップに戻る
    // window.history.length は自分を含めるので、1つ前に戻れる条件は2要素以上あるとき
    // 2要素あっても戻れないことがあるので3にしてみる(適当)→やっぱり2にしとく
    back_to(path = null) {
      if (window.history.length >= 2) {
        this.debug_alert("戻る")
        this.$router.go(-1)
      } else {
        this.debug_alert("戻れない")
        this.$router.push(path || "/")
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

    legacy_url_build(url, params) {
      const obj = new URL(this.as_full_url(url)) // URL には http から始まるURLしか渡せないので取ってはいけない
      _.each(params, (v, k) => obj.searchParams.set(k, v))
      return obj.toString()
    },

    // 通知
    simple_notify(message) {
      this.talk(message)
      this.$buefy.toast.open({message: message, position: "is-bottom", type: "is-info", duration: 1000 * 1, queue: false})
    },

    ////////////////////////////////////////////////////////////////////////////////

    // tweet_url_build_from_text("body")
    tweet_url_build_from_text(text) {
      return this.tweet_url_build_from_params({text: text})
    },

    // tweet_url_build_from_params({text: "body"})
    tweet_url_build_from_params(params) {
      const url = new URL("https://twitter.com/intent/tweet") // https://twitter.com/share と何が違う？
      _.each(params, (v, k) => {
        if (v) {
          url.searchParams.set(k, v)
        }
      })
      return url.toString()
    },

    // tweet_window_popup({text: "body"})
    // tweet_window_popup({url: "https://example.com/"})
    tweet_window_popup(params) {
      this.window_popup(this.tweet_url_build_from_params(params))
    },

    kento_full_url({sfen, turn, viewpoint}) {
      this.__assert__(sfen, "sfen is blank")

      const info = SfenParser.parse(sfen)
      const url = new URL("https://www.kento-shogi.com")

      // initpos は position sfen と moves がない初期局面の sfen
      url.searchParams.set("initpos", info.init_sfen_strip)

      // 視点も対応してくれるかもしれないので入れとく
      url.searchParams.set("viewpoint", viewpoint)

      // moves は別のパラメータでスペースを . に置き換えている(KENTOの独自の工夫)
      const { moves } = info.attributes
      if (moves) {
        url.searchParams.set("moves", moves.replace(/\s+/g, "."))
      }

      // #n が手数
      url.hash = turn

      return url.toString()
    },

    as_full_url(path) {
      if (!path.match(/^http/)) {
        path = this.$config.MY_SITE_URL + path
      }
      return path
    },

    ////////////////////////////////////////////////////////////////////////////////

    login_url_build(params = {}) {
      params = {
        ...params,
      }

      if (!params.return_to) {
        if (typeof location !== 'undefined') {
          params.return_to = location.href
        }
      }

      const usp = new URLSearchParams()
      _.each(params, (v, k) => usp.set(k, v))

      return this.$config.MY_SITE_URL + `/login?${usp}`
    },

    login_url_jump(params = {}) {
      if (typeof location !== 'undefined') {
        location.href = this.login_url_build(params)
      }
    },

    // login_required_legacy(params = {}) {
    //   if (!this.g_current_user) {
    //     this.login_url_jump(params)
    //     return true
    //   }
    // },

    sns_login_required() {
      if (!this.g_current_user || this.$route.query.sns_login_required === "on") {
        this.toast_ok("ログインしてください")
        this.sns_login_modal_open()
        return true
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    __assert__(value, message = null) {
      if (!value) {
        console.error(value)
        alert(message || "ぶっこわれました")
        debugger
      }
    },

    __assert_equal__(expected, actual, message = null) {
      if (actual !== expected) {
        console.error(`<${expected}> expected but was <${actual}>`)
        alert(message || "ぶっこわれました")
        debugger
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    // body ではなく html を対象にしないと隙間が見えてしまう
    html_background_color_set(color) {
      const elem = document.querySelector("html")
      elem.style.backgroundColor = color
    },

    html_background_color_unset() {
      this.html_background_color_set("unset")
    },

    // this.$el の background-color を html の background-color に設定する
    // これを使うより html_background_black_mixin.js を mixin する方がよい
    html_background_color_set_from_current_element() {
      const css_style_declaration = window.getComputedStyle(this.$el)
      const color = css_style_declaration.getPropertyValue("background-color")
      this.html_background_color_set(color)
    },

    // 一番下までスクロール
    scroll_to_bottom(elem) {
      if (elem) {
        this.$nextTick(() => {
          elem.scrollTop = elem.scrollHeight
        })
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

    user_call_name(str) {
      if (this.development_p) {
        this.__assert__(this.present_p(str), "this.present_p(str)")
      }
      return HandleNameParser.call_name(str)
    },

    // {a: 1, b: null, c:undefined, d: ""} => {a: 1, d: ""}
    hash_compact_if_null(hash) {
      return _.reduce(hash, (a, val, key) => {
        if (val == null) {
        } else {
          a[key] = val
        }
        return a
      }, {})
    },

    // {a: 1, b: null, c:undefined, d: ""} => {a: 1}
    hash_compact_if_blank(hash) {
      return _.reduce(hash, (a, val, key) => {
        if (val == null || val === "") {
        } else {
          a[key] = val
        }
        return a
      }, {})
    },

    // シンプルなハッシュに変換
    //
    // [
    //   { key: "column1", visible: true, },
    //   { key: "column2", visible: true, },
    // ]
    //
    //   ↓
    //
    // { xxx: true, yyy: false }
    //
    as_visible_hash(v) {
      return _.reduce(v, (a, e) => ({...a, [e.key]: e.visible}), {})
    },

    ////////////////////////////////////////////////////////////////////////////////

    hira_to_kata(str) {
      return str.replace(/[\u3041-\u3096]/g, ch => String.fromCharCode(ch.charCodeAt(0) + 0x60))
    },

    kata_to_hira(str) {
      return str.replace(/[\u30A1-\u30FA]/g, ch => String.fromCharCode(ch.charCodeAt(0) - 0x60))
    },

    ////////////////////////////////////////////////////////////////////////////////

    vibrate(argv) {
      if (window.navigator.vibrate) {
        window.navigator.vibrate(argv)
      }
    },
    click_vibrate() {
      this.vibrate(10)
    },
  },

  directives: {
    // Twitter で使われている絵文字に置き換える
    //
    // https://github.com/twitter/twemoji
    // https://qiita.com/tdkn/items/3e3d0d61338557ec259f
    //
    // 使い方: span(v-twemoji) {{message}}
    //
    // これによって解決される問題
    // ・Macで「ぴえん」が白黒
    // ・AndroidやWindowsで「ゴキブリ」が出ない
    // ・Windowsの残念な絵文字を置き換えれる
    //
    xemoji: {
      inserted(el) {
        el.innerHTML = twemoji.parse(el.innerHTML, { folder: "svg", ext: ".svg", className: "xemoji" })
      }
    },
  },
}
