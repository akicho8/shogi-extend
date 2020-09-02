// ここで buefy の loading をフックしたらいいのでは？
// Rails が外側にあるわけじゃないのでこれは意味がない
// See https://axios.nuxtjs.org/helpers

export default function ({ $axios, $buefy }) {
  $axios.onRequest(config => {
    // window.$loading = $buefy.loading.open()
    // console.log(`[axios_mod] loading=${window.$loading}`)

    if (process.client) {
      const el = document.querySelector('meta[name="csrf-token"]')
      if (el) {
        const value = el.getAttribute('content')
        $axios.setHeader("X-CSRF-Token", value)
        // config.headers.common['x-csrf-token'] = value
        // alert(config.headers.common['x-csrf-token'])
      } else {
        // Nuxt からいきなり起動しているのでタグがない
      }
    }

    // config.headers.common['x-csrf-token'] = "foo"
    // config.headers.common['ABC'] = "DEF"
  })

  $axios.onRequest(config => {
    console.log(`[axios_mod] onRequest`)
  })
  $axios.onResponse(response => {
    // if (window.$loading) { window.$loading.close(); window.$loading = null }
    console.log(`[axios_mod] onResponse`)
  })
  $axios.onError(err => {
    // if (window.$loading) { window.$loading.close(); window.$loading = null }
    console.log(`[axios_mod] onError`)
  })
  $axios.onRequestError(err => {
    // if (window.$loading) { window.$loading.close(); window.$loading = null }
    console.log(`[axios_mod] onRequestError`)
  })
  $axios.onResponseError(err => {
    // if (window.$loading) { window.$loading.close(); window.$loading = null }
    console.log(`[axios_mod] onResponseError`)
  })
}
