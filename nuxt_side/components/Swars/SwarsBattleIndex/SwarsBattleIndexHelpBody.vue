<template lang="pug">
.SwarsBattleIndexHelpBody
  .content
    article
      h2 将棋ウォーズ棋譜検索はぴよ将棋か？
      .article_body
        ul.mt-2
          li ぴよ将棋ではない
    article
      h2 将棋ウォーズ棋譜検索はKENTOか？
      .article_body
        ul.mt-2
          li KENTOではない
    article
      h2 歯抜けになる
      .article_body
        ul.mt-2
          li 「右上メニュー」→「古い棋譜を補完」
    article
      h2 歯抜けにならないようにするには？
      .article_body
        ul.mt-2
          li 同じルールで連続11回対局する前に棋譜検索する
    article
      h2 まとめてダウンロードするには？
      .article_body
        ul.mt-2
          li 「右上メニュー」→「ダウンロード」
    article
      h2 前の続きからダウンロードするには？
      .article_body
        ul.mt-2
          li 「右上メニュー」→「ダウンロード」→「前回の続きから」
    article
      h2 指定ウォーズIDの棋譜がすべて欲しい
      .article_body
        ul.mt-2
          li 「右上メニュー」→「古い棋譜を補完」→「ZIPファイルの添付」
    article
      h2 棋譜コピーではなくファイル保存したい
      .article_body
        ul.mt-2
          li 「右上メニュー」→「一覧の<i class="mdi mdi-dots-vertical mdi-18px" />」→「保存」
    article
      h2 UTF-8 とか Shift_JIS とかって何？
      .article_body
        ul.mt-2
          li Windows を使っている場合は Shift_JIS
    article
      h2 名前の前にあるアイコンの意味は？
      .article_body
        ul.mt-2
          li そのアイコンをタップする
    article
      h2 ゴキブリなんとかしろ
      .article_body
        ul.mt-2
          li 普通に対局していれば出ないようにしたので安心してください
    article
      h2 毎回ウォーズIDを入力するのが面倒
      .article_body
        ul.mt-2
          li 「右上メニュー」→「ウォーズIDを記録する」
    article
      h2 対戦相手で絞り込みたい
      .article_body
        ul.mt-2
          li 「右上メニュー」→「カスタム検索」
    article
      h2 横断検索したい
      .article_body
        ul.mt-2
          li DBが死ぬので一般には公開してない
          li が、検索条件を伝えてくれれば手動で棋譜を用意することはできる
    article
      h2 消費時間を視覚的に確認したい
      .article_body
        ul.mt-2
          li 「詳細」
    article
      h2 掲示板に棋譜を貼りたいのでKI2が欲しい
      .article_body
        ul.mt-2
          li 「詳細」→「右上メニュー」→EXPORT各種
    article
      h2 指定の局面の画像が欲しい
      .article_body
        ul.mt-2
          li 「詳細」→指定の局面にする→「右上メニュー」→「ダウンロード」→「PNG」
    article
      h2 指定の局面をツイートしてOGP画像を出したい
      .article_body
        ul.mt-2
          li 「詳細」→指定の局面にする→右上のツイートリンク
    article
      h2 棋譜を棋譜用紙にしたい
      .article_body
        ul.mt-2
          li 「詳細」→「右上メニュー」→「棋譜用紙 (PDF)」
    article
      h2 棋譜を印刷したい
      .article_body
        ul.mt-2
          li 「詳細」→「右上メニュー」→「棋譜用紙 (PDF)」
    article
      h2 棋譜を動画にしたい
      .article_body
        ul.mt-2
          li 「詳細」→「右上メニュー」→「動画作成」
    article
      h2 棋譜を問題にしたい
      .article_body
        ul.mt-2
          li 「詳細」→「右上メニュー」→「問題作成」
    article
      h2 棋譜を元に詰将棋を作りたい
      .article_body
        ul.mt-2
          li 「詳細」→「右上メニュー」→「共有将棋盤に転送」
    article
      h2 ここに載ってない
      .article_body
        p
          | →
          a.mx-1(href="https://twitter.com/sgkinakomochi") @sgkinakomochi
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "SwarsBattleIndexHelpBody",
  mixins: [
    support_child,
  ],
  data() {
    return {
      tab_index: 0,
    }
  },
}
</script>

<style lang="sass">
@import "support.sass"
.SwarsBattleIndexHelpBody
  padding: 1.5rem
  article
    &:not(:first-child)
      margin-top: 2.5rem
    h2
      font-size: $size-5
      font-weight: bold
    .article_body
      margin-left: 1rem
      th
        white-space: nowrap
</style>
