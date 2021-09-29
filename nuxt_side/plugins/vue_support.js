// 汎用コード
import { Gs } from "../components/models/gs.js"
import { SpUtils } from "../components/models/sp_utils.js"
import twemoji from 'twemoji'
import _ from "lodash"

export default {
  methods: {
    ...Gs,
    ...SpUtils,

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
