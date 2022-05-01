<template lang="pug">
.SwarsBattleIndexHelpBody
  .content(v-decorate)
    article
      h2 将棋ウォーズ棋譜検索はぴよ将棋か？
      ul
        li ぴよ将棋ではない
    article
      h2 将棋ウォーズ棋譜検索はKENTOか？
      ul
        li KENTOではない
    article
      h2 歯抜けになる
      ul
        li MENU→古い棋譜を補完
    article
      h2 「古い棋譜を補完」やったけど1ヶ月以上前の棋譜が出てこない
      ul
        li 1ヶ月以上前の棋譜は取り込めない
    article
      h2 歯抜けにならないようにするには？
      ul
        li 同じルールで連続11回対局する前に棋譜検索する
    article
      h2 対局を終えた直後に検索しても出てこないときがある
      ul
        li 最長3分待ってから検索する
    article
      h2 ウォーズIDはわからんがウォーズの対局URLだけはわかっている
      ul
        li そのまま検索覧に放り込む
    article
      h2 まとめてダウンロードするには？
      ul
        li MENU→ダウンロード
    article
      h2 前回の続きからダウンロードするには？
      ul
        li MENU→ダウンロード→前回の続きから
    article
      h2 指定ウォーズIDの棋譜がすべて欲しい
      ul
        li MENU→古い棋譜を補完→ZIPファイルの添付
    article
      h2 棋譜コピーではなくファイルが欲しい
      ul
        li MENU→一覧<i :class="dot_vertical" />→保存
    article
      h2 UTF-8 とか Shift_JIS とかって何？
      ul
        li Windows を使っている場合は Shift_JIS

    article
      h2 毎回ウォーズIDを入力するのが面倒
      ul
        li MENU→ウォーズIDを記録する

    article
      h2 名前の前にあるアイコンの意味は？
      ul
        li そのアイコンをタップする
    article
      h2 ゴキブリなんとかしろ
      ul
        li 普通に対局していれば出ないようにしたので安心してください

    article
      h2 検討のため負けた棋譜だけ欲しい
      ul
        li MENU→カスタム検索
    article
      h2 10分切れ負けの棋譜だけ欲しい
      ul
        li MENU→カスタム検索
    article
      h2 対戦相手で絞り込みたい
      ul
        li MENU→カスタム検索
    article
      h2 横断検索したい
      ul
        li 一般には公開してないけど検索条件を言ってくれれば可能な範囲で棋譜を用意します
    article
      h2 1手毎の消費時間を視覚的に確認したい
      ul
        li 詳細

    article
      h2 掲示板に棋譜を貼りたいのでKI2形式が欲しい
      ul
        li 詳細→MENU→EXPORT各種

    article
      h2 指定局面の画像が欲しい
      ul
        li 詳細→指定局面にする→MENU→ダウンロード→PNG
    article
      h2 指定局面をツイートしてOGP画像を出したい
      ul
        li 詳細→指定局面にする→右上のツイートリンク
    article
      h2 棋譜をPDF形式の棋譜用紙にしたい
      ul
        li 詳細→MENU→棋譜用紙→PDFに印刷
    article
      h2 棋譜を印刷したい
      ul
        li 詳細→MENU→棋譜用紙→PDFに印刷→それを本当に印刷
    article
      h2 会心譜を印刷して飾りたいがプリンタを持っていない
      ul
        li 詳細→MENU→棋譜用紙→PDFに印刷→ネットプリント→コンビニ
    article
      h2 棋譜を元に詰将棋を作りたい
      ul
        li 詳細→MENU→共有将棋盤に転送
    article
      h2 SNSにスクショを投稿するので相手の名前を隠したい
      ul
        li MENU→一覧<i :class="dot_vertical" />→相手の名前

    article
      h2 ミニマリスト化
      ul
        li MENU→一覧<i :class="dot_vertical" />→すべてOFFにした上でもっとも使うものだけONにする

    article
      h2 どっちが勝ったの？
      ul
        li 名前の濃い方

    article
      h2 戦法とかの判定でたらめじゃん
      ul
        li SNSでより詳細に愚痴る

    article
      h2 棋譜を動画にしたい
      ul
        li 詳細→MENU→動画作成
    article
      h2 棋譜を問題にしたい
      ul
        li 詳細→MENU→問題作成
    article
      h2 ここに載ってない
      ul
        li
          | →
          a.mx-1(href="https://twitter.com/sgkinakomochi") @sgkinakomochi
</template>

<script>
export default {
  name: "SwarsBattleIndexHelpBody",
  computed: {
    dot_vertical() { return "mdi mdi-dots-vertical mdi-18px" },
  },
  // https://jp.vuejs.org/v2/guide/custom-directive.html
  directives: {
    decorate: {
      inserted(el, binding, vnode) {
        let s = el.innerHTML
        const arrow = "➡"
        s = s.replace(/→/g, `&nbsp;&nbsp;${arrow}&nbsp;&nbsp;`)
        el.innerHTML = s
      },
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.SwarsBattleIndexHelpBody
  padding: 2rem
  article
    &:not(:first-child)
      margin-top: 2rem
    h2
      font-size: $size-7
      font-weight: bold
      // &::before
      //   content: "🔵 "
    ul
      list-style: none
</style>
