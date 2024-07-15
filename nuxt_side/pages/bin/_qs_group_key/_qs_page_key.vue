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
      const url = `/api/bin/${params.qs_group_key ?? '__qs_group_key_is_blank__'}/${params.qs_page_key ?? '__qs_page_key_is_blank__'}.json`
      // try {
      const meta = await $axios.$get(url, { params: { ...query, __FOR_ASYNC_DATA__: true } })
      return { meta }
      // } catch (err) {
      //   if (err.response && err.response.status === 404) {
      //     // 404エラーを投げてNuxt.jsのエラーページを表示
      //     error({ statusCode: 404, message: 'Page not found' })
      //   } else {
      //     // その他のエラー処理
      //     error({ statusCode: err.response ? err.response.status : 500, message: err.message })
      //   }
      // }
    }
  },
}
</script>
