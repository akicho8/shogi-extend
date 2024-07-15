// SEO関連パラメータの設定例
//
//   export default {
//     computed: {
//       meta() {
//         return {
//           title: "タイトル",
//           description: "説明",
//           og_image_key: "foo",
//         }
//       }
//     },
//   }
//

import _ from "lodash"

export class HeadGenerator {
  constructor(context) {
    this.context = context
    this.$config = context.$config
    this.meta = context.meta
    this.h = {}
  }

  generate() {
    if (!this.meta) {
      return {}
    }

    this.h.meta = []

    this.ordered_fetch("title", ["title"])
    this.ordered_fetch("og:title", ["og_title", "title"])
    this.ordered_fetch("description", ["description"])
    this.ordered_fetch("og:description", ["og_description", "description"])

    this.image_set()

    // page_title_only を有効にすると "bbb - aaa" を "bbb" にする
    if (this.meta.page_title_only) {
      this.h.titleTemplate = ""
    }

    if (this.meta.link) {
      this.h.link = this.meta.link
    }

    if (true) {
      // http://localhost:4000/?apple-mobile-web-app-capable=xxx
      // view-source:http://localhost:4000/?apple-mobile-web-app-capable=xxx
      const key = "apple-mobile-web-app-capable"
      const v = this.context.$route.query[key]
      if (v) {
        this.set_name(key, v)
      }
    }

    return this.h
  }

  //////////////////////////////////////////////////////////////////////////////// private

  image_set() {
    let s = null

    s = this.meta.og_image_key
    if (s) {
      s = this.$config.MY_NUXT_URL + `/ogp/${s}.png`
      this.set("og:image", s)
    }

    s = this.meta.og_image_path
    if (s) {
      s = this.$config.MY_SITE_URL + s
      this.set("og:image", s)
    }

    s = this.meta.og_video_path
    if (s) {
      s = this.$config.MY_SITE_URL + s
      this.set("og:video", s)
    }

    // nuxt.config.js で初期値を summary_large_image にしている
    s = this.meta.og_card_size  // small or large
    if (s === "small") {
      this.set("twitter:card", "summary") // summary or summary_large_image
    }
  }

  ordered_fetch(hkey, keys) {
    const key = keys.find(e => e in this.meta) // 空文字列はスルーされてしまうので仕方なく has_key? でチェック
    if (key) {
      this.set(hkey, this.meta[key])
    }
  }

  // <meta property="(key)" content="(value)" /> 形式用
  set(key, val) {
    if (_.isArray(val)) {
      val = _.compact(val).join(" - ")
    }
    val = val || ""
    if (key === "title") {
      this.h.title = val
    } else {
      this.h.meta.push({hid: key, property: key, content: val})
    }
  }

  // <meta name="(key)" content="(value)" /> 形式用
  set_name(key, val) {
    this.h.meta.push({hid: key, name: key, content: val})
  }
}
