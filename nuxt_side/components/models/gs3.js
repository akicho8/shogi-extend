export const Gs3 = {
  as_full_url(path) {
    if (!path.match(/^http/)) {
      path = __NUXT__.config.MY_SITE_URL + path
    }
    return path
  },
}
