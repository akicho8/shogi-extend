<template lang="pug">
.FetchTest
  b-button(@click="$fetch") $fetch()
  pre
    p $fetchState = {{$fetchState}}
    p one_record = {{one_record}}
</template>

<script>
export default {
name: "FetchTest",
  data() {
    return {
      one_record: [],
    }
  },
  // https://ja.nuxtjs.org/api/pages-fetch
  async fetch() {
    // this.one_record = await this.$axios.$get("https://jsonplaceholder.typicode.com/posts/1")
    // this.one_record = await this.$axios.$get("/api/echo")
    this.one_record = await this.$axios.$get("/api/echo")
  },
  fetchOnServer: false, // Boolean または Function（デフォルト: true）。サーバーがページをレンダリングする際に fetch() を呼び出します
  fetchDelay: 200,      // Integer（デフォルト: 200）。最小実行時間をミリ秒単位で設定します（過剰実行を防ぐため）。
}
</script>

<style lang="sass">
.FetchTest
</style>
