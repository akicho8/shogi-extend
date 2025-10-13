// 汎用コード
import { Gs        } from "@/components/models/gs.js"
import { AppHelper  } from "@/components/models/app_helper.js"
import { SpUtil     } from "@/components/models/sp_util.js"
import { MyMobile   } from "@/components/models/my_mobile.js"

import twemoji from 'twemoji'
import _ from "lodash"
const util = require("util")
const QueryString = require("query-string")

export const vue_support = {
  methods: {
    // ...Gs,
    ...AppHelper,
    ...SpUtil,

    ua_icon_key_get() {
      if (typeof window === "undefined") {
        return "question"
      } else {
        const ua = window.navigator.userAgent.toLowerCase()
        if (MyMobile.mobile_p) {
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
            return "mac"
          }
        }
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    ga_click(category) {
      if (this.$gtag) {
        if (this.$config.STAGE !== "production") {
          category = `(${this.$config.STAGE}) ${category}`
        }
        if (this.development_p) {
          const message = `GA: ${category}`
          const params = {message: message, position: "is-top", type: "is-dark", queue: false}
          if (this.__SYSTEM_TEST_RUNNING__) {
            // Capybara の assert_text が toast 要素だけにマッチしてしまうため表示しない
          } else {
            this.$buefy.toast.open(params)
          }
          this.clog(message)
        }
        this.$gtag("event", "click", {event_category: category})
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

    debug_alert_core(message, options = {}) {
      if (message != null) {
        this.$buefy.toast.open({
          message: message.toString(),
          position: "is-bottom",
          type: "is-danger",
          duration: 1000 * 4,
          queue: false,
          ...options,
        })
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    clog(...args) {
      if (this.development_p) {
        console.log(...args)
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    // vue の変数を見ようとするとほぼ setter/getter になってしまう。
    // safe_inspect(object, options = {}) {
    //   return this.util.inspect(object, {depth: null, maxArrayLength: null, breakLength: Infinity, showHidden: true, showProxy: true, ...options})
    // },

    // 1つ前に戻れるなら戻る
    // 戻れないならトップに戻る
    // window.history.length は自分を含めるので、1つ前に戻れる条件は2要素以上あるとき
    // 2要素あっても戻れないことがあるので3にしてみる(適当)→やっぱり2にしとく
    //
    // ↑この方法はうまくいかない
    //
    back_to() {
      this.back_to_or("/")
    },
    back_to_or(path) {
      Gs.assert(Gs.present_p(path), "Gs.present_p(path)")
      if (false) {
        // この方法でブラウザバックを行うとループする
        // 例えばリダイレクトで A → B ときた場合 B から戻るで再度 A → B が起きて B から上がれなくなる
        // なのでもう使わない
        if (typeof window !== "undefined") {
          if (window.history.state.back_to_ok) {
            this.$router.go(-1)
          } else {
            this.$router.push(path)
          }
        }
      } else {
        this.$router.push(path)
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
      return QueryString.stringifyUrl({
        url: "https://twitter.com/intent/tweet", // https://twitter.com/share と何が違う？
        query: params,
      })
    },

    // URLとテキストを含める場合に気をつけること
    //
    // 方法1. url と text を別に指定する → 1行目を空行にできない
    // this.tweet_window_popup({url: this.current_url, text: this.tweet_hash_tag})
    //
    // 方法2. 自力で text に url 含める → 1行目を空行にできる
    // this.tweet_window_popup({text: await this.tweet_body()})
    //
    tweet_window_popup(params) {
      this.window_popup(this.tweet_url_build_from_params(params))
    },

    ////////////////////////////////////////////////////////////////////////////////

    login_url_build(params = {}) {
      params = {
        ...params,
      }
      // 戻り先が設定されていなければ今のURLを設定しておく
      if (params.return_to == null) {
        if (typeof location !== 'undefined') {
          params.return_to = location.href
        }
      }
      return QueryString.stringifyUrl({url: this.$config.MY_SITE_URL + "/login", query: params})
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

    nuxt_login_required() {
      // http://localhost:4000/video/new?__nuxt_login_required_force=login
      if (!this.g_current_user || this.$route.query.__nuxt_login_required_force === "login") {
        this.toast_ok("ログインしてください")
        this.nuxt_login_modal_open()
        return true
      }
      // http://localhost:4000/video/new?__nuxt_login_required_force=email
      if (!this.g_current_user["email_valid?"] || this.$route.query.__nuxt_login_required_force === "email") {
        // アクティベートしてなければ email は空になっている
        this.toast_warn("正しいメールアドレスを設定してください")
        this.$router.push("/lab/account/email-edit")
        return true
      }
      // http://localhost:4000/video/new?__nuxt_login_required_force=name
      if (this.$gs.blank_p(this.g_current_user.name) || this.$route.query.__nuxt_login_required_force === "name") {
        // なぜか名前が空の人がいる
        this.toast_warn("名前を設定してください")
        this.$router.push("/lab/account/name-edit")
        return true
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

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
    // ここで $nextTick を指定するな
    scroll_to_bottom(elem) {
      if (elem) {
        elem.scrollTop = elem.scrollHeight
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    // b-input(@keydown.native.enter="enter_handle")
    //
    // enter_handle(e) {
    //   if (this.keyboard_enter_p(e)) {
    //     this.send_handle()
    //   }
    // },
    //
    // keyCode: 13   <-- 送信を意識した
    // keyCode: 229  <-- IMEで変換した
    //
    keyboard_enter_p(e) {
      return e.keyCode === 13
    },

    keyboard_meta_p(e) {
      return e.shiftKey || e.ctrlKey || e.altKey || e.metaKey
    },

    keyboard_shift_p(e) {
      return e.shiftKey
    },

    keyboard_meta_without_shift_p(e) {
      return e.ctrlKey || e.altKey || e.metaKey
    },

    keyboard_single_key_equal(e, key) {
      return !this.keyboard_meta_p(e) && e.key === key
    },

    keyboard_single_code_equal(e, code) {
      return !this.keyboard_meta_p(e) && e.code === code
    },

    focus_on_input_tag_p() {
      const dom = document.activeElement
      return dom.tagName === "TEXTAREA" || dom.tagName === "INPUT"
    },

    ////////////////////////////////////////////////////////////////////////////////

    // 本来は pointerType === "mouse" だけでいいはずだが、iPad の Google Chrome と iPad の Safari でも pointerType === "mouse" になってしまう
    // したがって maxTouchPoints でタッチ可能なデバイスならマウスではないとする
    mouse_event_p(e) {
      if (e) {
        const is_touch_capable = navigator.maxTouchPoints > 0
        return e.pointerType === "mouse" && !is_touch_capable
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    // this.app_log({level: "info", emoji: ":SOS:", subject: "(subject)", body: "(body)"})
    // this.app_log("(body)")
    app_log(params = {}) {
      if (typeof params === "string") {
        params = { body: params }
      }
      return this.$axios.$post("/api/app_log.json", params, {progress: false})
    },

    ////////////////////////////////////////////////////////////////////////////////

    // 自前の短縮URLを作る
    // url = await this.long_url_to_short_url(this.current_url)
    long_url_to_short_url(url) {
      return this.$axios.$post("/api/short_url/components.json", {original_url: url}, {progress: false})
    },

    ////////////////////////////////////////////////////////////////////////////////

    // await this.sleep(1)
    sleep(sec) {
      return new Promise(resolve => setTimeout(resolve, sec * 1000.0))
    },
  },

  // FIXME: plugin にする
  computed: {
    _()          { return _          },
    util()       { return util       },

    __SYSTEM_TEST_RUNNING__() {
      // if (this.development_p) {
      //   console.log("this.$route", this.$route)
      //   console.log("this.$route.query", this.$route.query)
      //   console.log("this.$route.query.__SYSTEM_TEST_RUNNING__", this.$route.query.__SYSTEM_TEST_RUNNING__)
      // }
      return this.$route.query.__SYSTEM_TEST_RUNNING__ === "true"
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
    // 【注意】
    // 更新されるテーブル内のtdでこれを使うと更新されないので次のように key をつける
    //   span(v-xemoji :key="name") {{name}}
    //   ↑これは面倒すぎるので XemojiWrap を使うこと
    //
    xemoji: {
      // https://jp.vuejs.org/v2/guide/custom-directive.html
      inserted(el) {
        el.innerHTML = twemoji.parse(el.innerHTML, {
          folder: "svg",
          ext: ".svg",
          className: "xemoji",
          // Twemojiが2023年になると表示されなくなる問題に対処する
          // https://zenn.dev/yhatt/articles/60ce0c3ca79994
          base: "https://cdn.jsdelivr.net/gh/twitter/twemoji@latest/assets/",
        })
      },
    },
  },
}
