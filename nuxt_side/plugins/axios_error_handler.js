// 以下のコードのエラー処理をまとめる
//
// return this.$axios.$post("/api/wkbk/books/save.json", {book: this.book}).catch(e => {
//   this.$nuxt.error(e.response.data)
//   return
// }).then(e => {
//
// const e = await this.$axios.$get("/api/wkbk/articles/show.json", {params}).catch(e => {
//   this.$nuxt.error(e.response.data)
//   return
// })

// https://axios.nuxtjs.org/helpers
export default function ({ $axios, redirect, error }) {
  // console.log('Axios maxRedirects:', $axios.defaults.maxRedirects) ← 見れない

  $axios.onRequest(config => {
    // $axios.setHeader を使うと server のときしか値が入らない(謎)
    // ヘッダーキーにアンダースコアを使うと何も言わずに削除されてめちゃくちゃはまる(怒)
    config.headers.common["AxiosProcessType"] = process.client ? "client" : "server"
  })

  $axios.onError(e => {
    //   if (process.server) {
    //     console.log(e.response)
    //     const code = parseInt(e.response && e.response.status);
    //     if (code === 401) {
    //       // オプションでリクエストが発生した元のパスを取得
    //       const originalRequestPath = e.config && e.config.url;
    //
    //       // リファラを取得
    //       const referrer = e.config && e.config.headers && e.config.headers.referer;
    //       console.log("referrer", referrer)
    //
    //       // // リファラが存在する場合はそのパスにリダイレクトする
    //       // if (referrer) {
    //       //   redirect(referrer);
    //       // } else if (originalRequestPath) {
    //       //   // 元のパスにリダイレクトする
    //       //   redirect(originalRequestPath);
    //       // } else {
    //       //   // パスが取得できない場合、デフォルトの処理を行う
    //       //   console.error('Redirect path not found.');
    //       //   // 例えば、トップページにリダイレクトする場合は以下のようにする
    //       //   redirect('/');
    //       // }
    //     }
    //     // その他のエラー処理をここに追加する
    //   }
    //
    //   // if (process.env.NODE_ENV === "development") {
    //   //   console.log(JSON.stringify(e, null, 2))
    //   //   console.log(JSON.stringify(e.response, null, 2)) ← これで 401 のときまた再帰的なエラーになる
    //   // }
    //
    //   // json: {} 内容が e.response.data に入っている
    //
    //   if (process.client) {

    error({statusCode: e.response?.status ?? 500, message: e.message, __RAW_ERROR_OBJECT__: e, __RESPONSE_DATA__: e.response?.data, call_from: "axios_error_handler.js"})

    //   }
    //
    //   // これを返すと $get が false を返して処理が継続してしまい、めちゃくちゃになる
    //   // return Promise.resolve(false)
  })

  // ↓まったく動かない。そもそも自動でリダイレクトしてくれるはず。
  // $axios.onResponse(response => {
  //   console.log(response)
  //   // 302 ステータスコードの場合
  //   if (response.status === 302) {
  //     // リダイレクト先URLを取得
  //     const redirectUrl = response.headers.location
  //     // リダイレクト
  //     if (redirectUrl) {
  //       redirect(redirectUrl)
  //     }
  //   }
  //   return response
  // })
}

// export default function ({$axios, error}) {
//   $axios.onError(e => {
//     const r = e.response
//
//     if (process.env.NODE_ENV === "development") {
//       console.log(JSON.stringify(r, null, 2))
//     }
//
//     // e.data.statusCode // => 403
//     // e.data.message    // => "非公開"
//
//     // e.status          // => 403
//     // e.statusText      // => "Forbidden"
//
//     if ("statusCode" in r.data) {
//       error(r.data)
//     } else {
//       error({statusCode: r.status, message: r.statusText})
//     }
//     return Promise.reject(e)
//     // return Promise.resolve(false) // これを返すと console への出力が減る ？ これがあると error で脱出しない？？？
//   })
// }

// ここで buefy の loading をフックしたらいいのでは？

// Rails が外側にあるわけじゃないのでこれは意味がない
// See https://axios.nuxtjs.org/helpers

// export default function ({ $axios, $buefy }) {
//   $axios.onRequest(config => {
//     // window.$loading = $buefy.loading.open()
//     // console.log(`[axios_mod] loading=${window.$loading}`)
//
//     if (process.client) {
//       const el = document.querySelector('meta[name="csrf-token"]')
//       if (el) {
//         const value = el.getAttribute('content')
//         $axios.setHeader("X-CSRF-Token", value)
//         // config.headers.common['x-csrf-token'] = value
//         // alert(config.headers.common['x-csrf-token'])
//       } else {
//         // Nuxt からいきなり起動しているのでタグがない
//       }
//     }
//
//     // config.headers.common['x-csrf-token'] = "foo"
//     // config.headers.common['ABC'] = "DEF"
//   })
//
//   if (process.env.NODE_ENV === "development") {
//     $axios.onRequest(config => {
//       console.log(`[axios_mod] onRequest`)
//       console.log(config)
//       console.log(`[baseURL] ${config.baseURL}`)
//       console.log(`[url] ${config.url}`)
//     })
//     $axios.onResponse(response => {
//       // if (window.$loading) { window.$loading.close(); window.$loading = null }
//       console.log(`[axios_mod] onResponse`)
//
//       // if (process.client) {
//       //   debugger
//       //   $buefy.toast.open("ok")
//       // }
//
//     })
//     $axios.onError(err => {
//       // if (window.$loading) { window.$loading.close(); window.$loading = null }
//       console.log(`[axios_mod] onError`)
//     })
//     $axios.onRequestError(err => {
//       // if (window.$loading) { window.$loading.close(); window.$loading = null }
//       console.log(`[axios_mod] onRequestError`)
//     })
//     $axios.onResponseError(err => {
//       // if (window.$loading) { window.$loading.close(); window.$loading = null }
//       console.log(`[axios_mod] onResponseError`)
//     })
//   }
// }
