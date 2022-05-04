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
        h2 初めて使ったけど10件程度しか出てこんぞ
        ul
          li MENU→古い棋譜を補完
      article
        h2 ZIPでくれ
        ul
          li MENU→ダウンロード
      article
        h2 棋力別の勝率とかどこで見れる？
        ul
          li 名前タップ
      article
        h2 プレイヤー情報って最大50件だけ？
        ul
          li <i :class="dot_vertical_icon" />→件数

      template(v-if="true")
        article
          h2 相手の情報を知りたい
          ul
            li 相手の名前をタップ
        article
          h2 相手の情報が少ない
          ul
            li 相手を検索する
        article
          h2 相手のIDを検索覧に入力するのが面倒
          ul
            li 相手の名前をタップ→相手の名前をタップ

    article
      h2 歯抜けを直すには？
      ul
        li MENU→古い棋譜を補完
    article
      h2 「古い棋譜を補完」をしてみたけどもっとあるはず
      ul
        li 1ヶ月より前の棋譜は取り込めない
    article
      h2 歯抜けにならないようにするには？
      ul
        li 同じルールで連続11回対局する前に検索する
    article
      h2 対局を終えた直後に検索しても出てこないときがある
      ul
        li 最長3分待ってから検索する
    article
      h2 ウォーズの対局URLだけはわかっている
      ul
        li そのまま検索覧に放り込む
    article
      h2 前回の続きからZIPでくれ
      ul
        li MENU→ダウンロード→前回の続きから
    article
      h2 指定IDの棋譜がすべて欲しい
      ul
        li MENU→古い棋譜を補完→ZIPファイルの添付

    template(v-if="true")
      article
        h2 SNSにスクショを投稿するとき相手の名前を隠すのが面倒
        ul
          li MENU→一覧<i :class="dot_vertical_icon" />→相手の名前
      article
        h2 相手より自分の名前を隠したい
        ul
          li MENU→一覧<i :class="dot_vertical_icon" />→自分の名前

    template(v-if="true")
      article
        h2 棋譜の体裁を整えてPDFにしたい
        ul
          li 詳細→MENU→棋譜用紙→編集→PDFに印刷
      article
        h2 棋譜を印刷したい
        ul
          li そのPDFを印刷
      article
        h2 会心譜を印刷して飾りたいがプリンタを持っていない
        ul
          li ネットプリント→コンビニ

    template(v-if="true")
      article
        h2 棋譜を動画にしてSNSに上げたい
        ul
          li 詳細→MENU→動画作成

      article
        h2 棋譜の検討結果を問題にして自分専用の問題集を作りたい
        ul
          li 詳細→MENU→問題作成

    template(v-if="true")
      article
        h2 ページ送りが面倒
        ul
          li MENU→件数
      article
        h2 終局図から目視で棋譜を探すには？
        ul
          li MENU→終局→件数→200
      article
        h2 毎回棋譜コピーしてファイル保存するのが面倒
        ul
          li MENU→一覧<i :class="dot_vertical_icon" />→保存
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
        h2 KIFデータへの直リンが欲しい
        ul
          li 詳細→MENU→表示→KIF
      article
        h2 指定局面の画像が欲しい
        ul
          li 詳細→局面調整→MENU→ダウンロード→PNG
      article
        h2 指定局面をツイートして自動的に画像を出したい
        ul
          li 詳細→局面調整→右上のツイートリンク
      article
        h2 ぴよ将棋に送るURLが欲しい
        ul
          li 詳細→MENU→短めの直リンコピー→ぴよ将棋
      article
        h2 将棋ウォーズ本家で棋譜再生したい
        ul
          li 詳細→MENU→本家
      article
        h2 対局の検討を元に詰将棋を作りたい
        ul
          li 詳細→MENU→共有将棋盤に転送→MENU→局面編集

    template(v-if="true")
      article
        h2 毎回ウォーズIDを入力するのが面倒
        ul
          li MENU→ウォーズIDを記録する
      article
        h2 直近の対局をぴよ将棋で検討したいだけなのに検索するのが面倒
        ul
          li MENU→外部アプリですぐ開く→ぴよ将棋

    template(v-if="true")
      article
        h2 勝った対局を見返して自己肯定感を高める
        ul
          li MENU→カスタム検索→勝ち
      article
        h2 負けた対局を見返してもやもやする
        ul
          li MENU→カスタム検索→負け
      article
        h2 相手で絞り込みたい
        ul
          li MENU→カスタム検索→対戦相手
      article
        h2 横断検索したい
        ul
          li 検索条件を伝えてくれれば可能な範囲で棋譜を用意します
      article
        h2 1手毎の消費時間を視覚的に確認したい
        ul
          li 詳細→下

    article
      h2 どっちが勝ち？
      ul
        li 名前の濃い方

    article
      h2 1ヶ月より前のは取り込めないというけど対局URLはわかっている
      ul
        li 対局URLさえわかっていれば(検索覧に放り込めば)取り込める

    article
      h2 昔あった棋譜が消えた
      ul
        li ディスク容量の関係でアクセスのない古いものは消している

    article
      h2 指導対局の平手戦から学びたい
      ul
        li <i :class="home_icon" />→将棋ウォーズ十段の成績→名前タップ→MENU→カスタム検索→平手

    article
      h2 将棋ウォーズのイベント上位者の棋譜を見たい
      ul
        li <i :class="home_icon" />→将棋ウォーズイベント上位の成績

    article
      h2 格上に勝った棋譜だけZIPでくれ
      ul
        li MENU→カスタム検索→力差1→勝ち→検索→MENU→ダウンロード

    article
      h2 特定IDをストーキングする
      ul
        li 特定IDで検索→ホーム画面に追加

    article
      h2 戦法とかの判定でたらめじゃん
      ul
        li Twitterでより詳細に愚痴る

    //- article
    //-   h2 自分のウォーズIDがわからない
    //-   ul
    //-     li 将棋ウォーズアプリのトップの下

    article
      h2 ミニマリスト化
      ul
        li MENU→一覧<i :class="dot_vertical_icon" />→すべてOFF→使うのだけON

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
    dot_vertical_icon() { return "mdi mdi-18px mdi-dots-vertical" },
    // mdi-18px
    home_icon()         { return "mdi mdi-home "         },
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
    word-break: break-all

    &:not(:first-child)
      margin-top: 1.5rem
    h2
      font-size: $size-7
      font-weight: bold
      // &::before
      //   content: "🔵 "
    ul
      list-style: none

  +mobile
    padding: 1rem
    font-size: $size-7
    article
      &:not(:first-child)
        margin-top: 1rem
      .mdi:before
        font-size: $size-7
    ul
      margin-left: 1rem
</style>
