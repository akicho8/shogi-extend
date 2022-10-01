<template lang="pug">
HelpContent.SwarsBattleIndexHelpBody
  template(v-if="true")
    article
      h2 将棋ウォーズ棋譜検索はぴよ将棋か？
      ul
        li いいえ
    article
      h2 将棋ウォーズ棋譜検索はKENTOか？
      ul
        li いいえ

  template(v-if="true")
    article
      h2 アイコンの意味は？
      ul
        li アイコンをタップする
    article
      h2 まとめてダウンロードしたい
      ul
        li ダウンロード
    article
      h2 初めて使ったけど10件程度しか出てこない
      ul
        li 古い棋譜を補完
    article
      h2 棋力別の勝率とかどこで見れる？
      ul
        li 名前タップ
    article
      h2 プレイヤー情報は最大50件だけ？
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
      li 古い棋譜を補完
  article
    h2 「古い棋譜を補完」をしてみたけどもっとあるはず
    ul
      li 1ヶ月より前の棋譜は取り込めない
  article
    h2 1ヶ月より前のは取り込めないというけど対局URLはわかっている
    ul
      li そのまま検索覧に放り込む
  article
    h2 歯抜けにならないようにするには？
    ul
      li 同じルールで連続11回対局する前に検索する
  article
    h2 対局を終えた直後に検索しても出てこないときがある
    ul
      li 最長3分待ってから検索する
  article
    h2 前回の続きからダウンロードしたい
    ul
      li ダウンロード→前回の続きから
  article
    h2 指定IDの棋譜がすべて欲しい
    ul
      li 古い棋譜を補完→ZIPファイルの添付

  template(v-if="true")
    article
      h2 SNSにスクショを投稿するとき相手の名前を隠すのが面倒
      ul
        li 一覧<i :class="dot_vertical_icon" />→相手の名前
    article
      h2 相手より自分の名前を隠したい
      ul
        li 一覧<i :class="dot_vertical_icon" />→自分の名前

  template(v-if="true")
    article
      h2 棋譜の体裁を整えてPDFにしたい
      ul
        li 詳細→棋譜用紙→PDFに印刷
    article
      h2 棋譜を印刷したい
      ul
        li そのPDFを印刷
    article
      h2 プリンタを持っていない
      ul
        li ネットプリント→コンビニ
    article
      h2 棋譜用紙の備考などを編集したい
      ul
        li そのまま編集できる

  template(v-if="true")
    article
      h2 棋譜を動画にしてSNSに上げたい
      ul
        li 詳細→動画作成

    article
      h2 棋譜の検討結果を問題にして自分専用の問題集を作りたい
      ul
        li 詳細→問題作成

  template(v-if="true")
    article
      h2 ページ送りが面倒
      ul
        li 件数→200
    article
      h2 一覧の表示が遅い
      ul
        li 件数→10
    article
      h2 終局図から目視で棋譜を探す
      ul
        li 終局→件数→200
    article
      h2 毎回棋譜コピーしてファイル保存するのが面倒
      ul
        li 一覧<i :class="dot_vertical_icon" />→保存
    article
      h2 UTF-8 や Shift_JIS の意味は？
      ul
        li Windows なら Shift_JIS
    article
      h2 掲示板に棋譜を貼りたい
      ul
        li 詳細→コピー→KI2
    article
      h2 一時的にKIFファイルが欲しい
      ul
        li 詳細→ダウンロード→KIF
    article
      h2 KIFへの直リンクが欲しい
      ul
        li 詳細→表示→KIF
    article
      h2 指定局面の画像が欲しい
      ul
        li 詳細→局面調整→ダウンロード→PNG
    article
      h2 指定局面をツイートして自動的に画像を出したい
      ul
        li 詳細→局面調整→右上のツイートリンク
    article
      h2 ぴよ将棋に送るURLが欲しい
      ul
        li 詳細→短めの直リンコピー→ぴよ将棋
    article
      h2 将棋ウォーズ本家で棋譜再生したい
      ul
        li 詳細→本家
    article
      h2 対局の検討を元に詰将棋を作りたい
      ul
        li 詳細→共有将棋盤に転送→局面編集

  template(v-if="true")
    article
      h2 毎回ウォーズIDを入力するのが面倒
      ul
        li ウォーズIDを記録する
    article
      h2 直近の対局をぴよ将棋で検討したいだけなのに検索するのが面倒
      ul
        li 外部アプリですぐ開く→ぴよ将棋
    article
      h2 直近の対局をKENTOで検討したいだけなのに検索するのが面倒
      ul
        li 外部アプリですぐ開く→KENTO

  template(v-if="true")
    article
      h2 勝った対局を見返す
      ul
        li カスタム検索→勝ち
    article
      h2 負けた対局を見返す
      ul
        li カスタム検索→負け
    article
      h2 相手で絞り込む
      ul
        li カスタム検索→対戦相手
    article
      h2 横断検索したい
      ul
        li 検索条件を伝えてくれれば可能な範囲で棋譜を用意します
    article
      h2 1手毎の消費時間を視覚的に確認したい
      ul
        li 詳細

  article
    h2 どっちが勝ち？
    ul
      li 名前の濃い方

  article
    h2 囲いの名前が表示されない
    ul
      li 一覧<i :class="dot_vertical_icon" />→囲い

  article
    h2 入力履歴を消したい
    ul
      li 各自のブラウザで該当する Local Storage を削除する

  article
    h2 昔あった棋譜が消えた
    ul
      li ディスク容量の関係でアクセスのない古いものは消している

  article
    h2 指導対局の平手戦から学びたい
    ul
      li <i :class="home_icon" />→将棋ウォーズ十段の成績→名前タップ→カスタム検索→平手

  article
    h2 将棋ウォーズのイベント上位者の棋譜を見たい
    ul
      li <i :class="home_icon" />→将棋ウォーズイベント上位の成績

  article
    h2 格上に勝った棋譜だけダウンロードしたい
    ul
      li カスタム検索→力差1以上→勝ち→検索→ダウンロード

  article
    h2 特定IDをストーキングする
    ul
      li 特定IDで検索→ホーム画面に追加

  article
    h2 将棋ウォーズ本家のマイページに飛びたい
    ul
      li プレイヤー情報→<i :class="dot_vertical_icon" />→ウォーズ本家

  article
    h2 戦法等の判定がおかしい
    ul
      li Twitterで詳細を投稿する

  article
    h2 表示がごちゃごちゃして見にくい
    ul
      li 一覧<i :class="dot_vertical_icon" />→すべてOFF→使うのだけON

  article
    h2 将棋ウォーズ棋譜検索を使いたくない
    ul
      li 2000年ぐらいから本家側で棋譜コピーできるようになった

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
}
</script>

<style lang="sass">
@import "support.sass"
.SwarsBattleIndexHelpBody
  ul
    list-style: none
</style>
