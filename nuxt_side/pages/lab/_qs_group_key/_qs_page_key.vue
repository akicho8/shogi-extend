<template lang="pug">
QuickScriptView
</template>

<script>
export default {
  // JavaScript も解釈できないクローラが来たとき用にタイトルなどを設定する。
  // 必要があるのは meta 情報のみなのでレスポンスは速い。
  // CSR 時もページ遷移のときに呼ばれそうになるがこちらでは process.server のときだけとしている。
  // QuickScriptView で meta を設定するため process.client のときはここで呼ぶ必要がない。
  // 呼ぶと二重にリクエストが飛んで無駄になる。
  // QuickScriptView は fetchOnServer: false としている。
  async asyncData({ $axios, params, query, error }) {
    if (process.server) {
      const url = `/api/lab/${params.qs_group_key ?? '__qs_group_key_is_blank__'}/${params.qs_page_key ?? '__qs_page_key_is_blank__'}.json`
      try {
        const meta = await $axios.$get(url, { params: { ...query, __FOR_ASYNC_DATA__: true } })
        return { meta }
      } catch (e) {
        // console.warn(e)
        // console.warn(e.response)
        // console.warn(e.response.status)
        // console.warn(e.response.statusText)
        // console.warn(e.message)
        // SSR で 404 が返ってきたときここの処理がないと 500 エラーの nuxt.js のエラー画面になってしまう
        error({statusCode: e.response?.status ?? 500, message: e.message, __RAW_ERROR_OBJECT__: e, __RESPONSE_DATA__: e.response?.data})
      }
    }
  },
}
</script>
