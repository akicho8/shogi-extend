import { HeadGenerator } from "@/components/models/head_generator.js"

export const vue_head = {
  head() {
    const head_generator = new HeadGenerator(this)
    return head_generator.generate()

    // const h = {
    //   meta: [],
    // }
    // const m = this.meta
    // let s = null
    //
    // if (!m) {
    //   return {}
    // }
    //
    // if (m.title) {
    //   h.title = m.title
    // }
    //
    // s = m.og_title || m.title
    // if (s) {
    //   h.meta.push({hid: "og:title", property: "og:title", content: s})
    // }
    //
    // s = m.titleTemplate
    // if (s !== undefined) {
    //   h.titleTemplate = s
    // }
    //
    // s = m.description
    // if (s) {
    //   h.meta.push({hid: "description", name: "description", content: s})
    // }
    //
    // s = m.og_description || m.description
    // if (s) {
    //   h.meta.push({hid: "og:description", property: "og:description", content: s})
    // }
    //
    // s = m.og_image_key
    // if (s) {
    //   s = this.$config.MY_NUXT_URL + `/ogp/${s}.png`
    //   h.meta.push({hid: "og:image", property: "og:image", content: s})
    // }
    //
    // s = m.og_image
    // if (s) {
    //   h.meta.push({hid: "og:image", property: "og:image", content: s})
    // }
    //
    // s = m.twitter_card_is_small
    // if (s) {
    //   h.meta.push({hid: "twitter:card", property: "twitter:card", content: "summary"})
    // }
    //
    // return h
  },
}
