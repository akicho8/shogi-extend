const strip_tags = require("striptags")
import Autolinker from "autolinker"

export const Xhtml = {
  // ../../../node_modules/autolinker/README.md
  // newWindow: true で target="_blank" になる
  auto_link(str, options = {}) {
    return Autolinker.link(str, {newWindow: true, truncate: 30, mention: "twitter", ...options})
  },

  simple_format(str) {
    return str.replace(/\n/g, "<br/>")
  },

  // strip_tags(html)
  // strip_tags(html, "<strong>")
  // strip_tags(html, ["a"])
  // strip_tags(html, [], "\n")
  strip_tags(...args) {
    return strip_tags(...args)
  },
}
