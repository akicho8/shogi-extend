<template lang="pug">
.about-terms
  MainNavbar
    template(slot="brand")
      NavbarItemHome
      b-navbar-item.has-text-weight-bold サービス利用規約

  MainSection
    .container
      .content
        ul.mt-0
          li 重いからって連打してはいけない
          li ぴよ将棋アプリから将棋ウォーズ棋譜検索に来れるからといってぴよ将棋と混同してはいけない
          li 「KENTO」と混同してはいけない
          li SHOGI-EXTENDの仕様についてHEROZに問い合わせてはいけない
</template>

<script>
export default {
  name: "about-terms",
  computed: {
    meta() {
      return {
        title: "サービス利用規約",
      }
    },
  },
}
</script>
