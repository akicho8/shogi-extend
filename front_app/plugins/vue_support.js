// 汎用コード

import { SfenParser } from "shogi-player/components/models/sfen_parser.js"

const strip_tags = require('striptags')

import { isMobile } from "../components/models/is_mobile.js"

import Autolinker from 'autolinker'

import _ from "lodash"

export default {
  methods: {
    mobile_p()  { return isMobile.any()  },
    desktop_p() { return !isMobile.any() },

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

    delay_block(seconds, block) {
      return setTimeout(block, 1000 * seconds)
    },

    delay_stop(delay_id) {
      if (delay_id) {
        clearTimeout(delay_id)
      }
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

    ruby_like_modulo(v, n) {
      if (n === 0) {
        throw new Error("divided by 0")
      }
      v = v % n
      v = Math.trunc(v)
      if (v < 0) {
        v = n + v
      }
      return v + 0
    },

    ary_cycle_at(ary, index) {
      return ary[this.ruby_like_modulo(index, ary.length)]
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
        return this.other_window_open(url)
      }

      // this.process_now()
      location.href = url
    },

    other_window_open(url) {
      window.open(url, "_blank")
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

    ////////////////////////////////////////////////////////////////////////////////

    window_popup(url, options = {}) {
      options = {
        width: 800,
        height:640,
        ...options,
      }
      const left = (window.screen.width  - options.width)  / 2
      const top  = (window.screen.height - options.height) / 2
      const opts = `status=no,top=${top},left=${left},width=${options.width},height=${options.height}`
      window.open(url, "_blank", opts)
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
      if (!this.g_current_user) {
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

    // call_name("SOS団")  → "SOS団"
    // call_name("ありす") → "ありすさん"
    user_call_name(name) {
      name = name.replace(/(\D+)\d+/, "$1")    // "foo123" → "foo"
      if (name.match(/.(さん|サン|ｻﾝ|くん|クン|ｸﾝ|ちゃん|チャン|ﾁｬﾝ|マン|さま|サマ|ｻﾏ|様|氏|段|級|団|冠)[!！]?$/)) {
        return name
      }
      if (name.match(/.(コ|ｺ|こ|子)$/)) {
        return `${name}ちゃん`
      }
      if (name.match(/.(王)$/)) { // "女王" → "女王様"
        return `${name}様`
      }
      return `${name}さん`
    },

    // {a: 1, b: null} => {a: 1}
    hash_compact_if_null(hash) {
      return _.reduce(hash, (a, val, key) => {
        if (val == null) {
        } else {
          a[key] = val
        }
        return a
      }, {})
    },

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
  },

  computed: {
    // スマホ → _self
    //    PC  → _blank
    target_default() {
      return isMobile.any() ? "_self" : "_blank"
    },
  },
}
