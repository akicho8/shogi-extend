<template lang="pug">
.SwarsBattleIndexHelpBody
  .content(v-decorate)
    template(v-if="true")
      article
        h2 将棋ウォーズ棋譜検索はぴよ将棋か？
        ul
          li ぴよ将棋ではない
      article
        h2 将棋ウォーズ棋譜検索はKENTOか？
        ul
          li KENTOではない

    template(v-if="true")
      article
        h2 名前の前にあるアイコンの意味は？
        ul
          li そのアイコンをタップする
      article
        h2 自分のウォーズIDがわからない
        ul
          li 将棋ウォーズアプリのトップの下
      article
        h2 初めて使ったんだが10件程度しか出てこないぞ
        ul
          li MENU→古い棋譜を補完
      article
        h2 棋力別の勝率とかどこで見れる？
        ul
          li 名前タップ
      article
        h2 プレイヤー情報って直近50件だけ？
        ul
          li MENU→件数
      article
        h2 対戦相手の情報が知りたい
        ul
          li 対戦相手の名前をタップ
      article
        h2 対戦相手の情報が少ない
        ul
          li 対戦相手を検索する

    article
      h2 歯抜けになる
      ul
        li MENU→古い棋譜を補完
    article
      h2 「古い棋譜を補完」をしてみたけど1ヶ月以上前の棋譜が出てこない
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
      h2 ウォーズIDとやらはわからんがウォーズの対局URLだけはわかっている
      ul
        li そのまま検索覧に放り込む
    article
      h2 まとめてダウンロードしたい
      ul
        li MENU→ダウンロード
    article
      h2 前回の続きからダウンロードしたい
      ul
        li MENU→ダウンロード→前回の続きから
    article
      h2 指定ウォーズIDの棋譜がすべて欲しい
      ul
        li MENU→古い棋譜を補完→ZIPファイルの添付

    template(v-if="true")
      article
        h2 毎回棋譜コピーしてファイル保存するのが面倒
        ul
          li MENU→一覧<i :class="dot_vertical" />→保存
      article
        h2 UTF-8 や Shift_JIS とかって何？
        ul
          li Windows なら Shift_JIS
      article
        h2 掲示板に棋譜を貼りたい
        ul
          li 詳細→MENU→コピー→KI2
      article
        h2 一時的にKIFファイルが欲しい
        ul
          li 詳細→MENU→ダウンロード→KIF
      article
        h2 KIFデータへの直リンクが欲しい
        ul
          li 詳細→MENU→表示→KIF
      article
        h2 指定局面の画像が欲しい
        ul
          li 詳細→指定局面にする→MENU→ダウンロード→PNG
      article
        h2 指定局面をツイートして自動的に画像を出したい
        ul
          li 詳細→指定局面にする→右上のツイートリンク
      article
        h2 ぴよ将棋に送るURLが欲しい
        ul
          li 詳細→MENU→短めの直リンコピー→ぴよ将棋
      article
        h2 将棋ウォーズ本家で棋譜再生したい
        ul
          li 詳細→MENU→本家
      article
        h2 棋譜を棋譜用紙にしたい
        ul
          li 詳細→MENU→棋譜用紙→PDFに印刷
      article
        h2 棋譜を印刷したい
        ul
          li 詳細→MENU→棋譜用紙→PDFに印刷→PDFを紙に印刷
      article
        h2 会心譜を印刷して飾りたいがプリンタを持っていない
        ul
          li ネットプリント→コンビニ
      article
        h2 棋譜を元に詰将棋を作りたい
        ul
          li 詳細→MENU→共有将棋盤に転送→MENU→局面編集

    template(v-if="true")
      article
        h2 SNSにスクショを投稿するとき相手の名前を隠すのが面倒
        ul
          li MENU→一覧<i :class="dot_vertical" />→相手の名前
      article
        h2 相手より自分の名前を隠したい
        ul
          li MENU→一覧<i :class="dot_vertical" />→自分の名前

    article
      h2 毎回ウォーズIDを入力するのが面倒
      ul
        li MENU→ウォーズIDを記録する

    template(v-if="true")
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
      h2 ミニマリスト化
      ul
        li MENU→一覧<i :class="dot_vertical" />→すべてOFFにした上でもっとも使うものだけONにする

    template(v-if="true")
      article
        h2 ゴキブリなんとかしろ
        ul
          li 普通に対局していれば出ないようにしたので安心してください

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
