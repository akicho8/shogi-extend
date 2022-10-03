import { Xassertion } from "./core/xassertion.js"

export const Gs3 = {
  as_full_url(path) {
    if (!path.match(/^http/)) {
      Xassertion.__assert__(__NUXT__, "__NUXT__")
      path = __NUXT__.config.MY_SITE_URL + path
    }
    return path
  },
}
