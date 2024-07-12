// plugins/axios_loading.js
function finalize(store) {
  store.commit("g_axios_loading_set", false)
}

export default function ({ $axios, store }) {
  // リクエストインターセプター
  $axios.onRequest(config => {
    store.commit("g_axios_loading_set", true)
    return config
  })

  // レスポンスインターセプター
  $axios.onResponse(response => {
    finalize(store)
    return response
  })

  // エラーハンドリングインターセプター
  $axios.onError(error => {
    finalize(store)
    return Promise.reject(error)
  })
}
