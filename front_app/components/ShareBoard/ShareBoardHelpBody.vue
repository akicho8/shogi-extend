<template lang="pug">
.ShareBoardHelpBody
  //- b-tabs(v-model="tab_index")
  //-   b-tab-item(label="使い方")
  //- b-tab-item(label="FAQ")
  //-   .content
  .content
    article
      h2 リアルタイムなペア将棋
      .article_body
        p
          | リアルタイムに複数人同士で対戦する方式です。いろいろセルフサービス的なところがあります。
        ol
          li 「部屋に入る」で「合言葉」と「ハンドルネーム」を入力して入室する
          li 設定した合言葉を他の仲間にも伝えて同様に入室してもらう
          li 全員揃ったあと、必要であれば「手合割」を設定する
          li 「順番設定」する
          li 「時計設定」する
          li 後手または上手の人は☗か☖をタップして反転する
          li 順番に指していく
          li 何か伝えたいことがあれば右上のメッセージボタンから発言する
          li 「反則の取り消し」や「待った」したい場合は合意を得た上で「1手戻す」を実行して指し直す
          li 投了は右上のメッセージボタンから発言する
          li 対局終了後は時計を停止する (盤の下のコントローラーが表示される)
          li 対局終了後に検討する場合は「順番設定」を解除する (順番に関係なく駒を動かせるようにするため)
          li 再度対局するには「初期配置に戻す」を実行する

    article
      h2 ツイッターを利用したリレー将棋
      .article_body
        p
          | 1手指してツイートを繰り返す方式です。ツイート時には次に指す人を指名します。
        ol
          li メニューの「タイトル変更」で任意のタイトルに変更する (初回のみ)
          li  「ツイート画像の視点設定」を「1手指し継いだとき自分の視点」に変更する (初回のみ)
          li 1手指す
          li ツイートボタンからツイートして次の人を指名する
        p
          | 指し手の情報はすべてURLに含まれるので、指名されていない人が盤を動かしても、指名された人が指す局面には何も影響ありません

    article
      h2 対面でリアル対戦
      .article_body
        p
          | スマホやタブレットをテーブルに置いて二人で向かいあって指す方式です。そのまま指してください。上下対称です。
        ol
          li 必要であれば「時間設定」する
          li 必要であれば「手合割」をする
          li そのまま指す

    article
      h2 課題局面や詰将棋の作成と公開
      .article_body
        ol
          li 「局面編集」から任意の局面を作成
          li ツイートボタンからツイート

    article
      h2 盤が同期してなくない？
      .article_body
        p
          | 盤の同期は次の操作をしたときです。
        ul
          li 新しい手を指したとき
          li 「初期配置に戻す」を実行したとき
          li 「1手戻す」を実行したとき
          li 「局面の転送」を実行したとき
          li 「手合割」を適用したとき
        p
          | 盤の下のコントローラーで動かしたときの変化は自分の盤だけです。

    article
      h2 ハンドルネームを変更するには？
      .article_body
        ul
          li メニューの「部屋に入る」から「退室」
        p
          | 順番設定後に変更すると再度順番設定が必要になる

    article
      h2 上書きしてしまった棋譜を本筋に戻すには？
      .article_body
        p
          | 右側の履歴に駒を動かす前の指し手があればそれをタップする

    article
      h2 駒落ちで対戦するには？
      .article_body
        p
          | 「手合割」を選択

    article
      h2 手合割のプリセットに希望のものがないんだが？
      .article_body
        ol
          li 「局面編集」で自由に作る
          li 「局面の転送」を選択

    article
      h2 二歩・王手放置・持将棋・千日手の判定は？
      .article_body
        p
          | 駒が動ける場所の単純な縛りと死に駒回避はいれていますが、
          | それ以外なんもないので、お手数ですが対戦者同士で判断してください

    article
      h2 トライルールはある？
      .article_body
        p
          | 判定はないのであらかじめ対戦者同士で決めてください

    article
      h2 反則したけど指し直していいと言われたら？
      .article_body
        ol
          li 「1手戻す」を選択
          li 合法手を指す

    article
      h2 スマホで音飛びするんだが？
      .article_body
        p
          | 原因はわかりませんが同時に動いているアプリ(タスク)が干渉しているのかもしれないので、いったんすべてのアプリ(タスク)を終了させてみてください

    article
      h2 スマホで最初に画面に触れたとたんいろんな音がまざって出たんだが？
      .article_body
        p
          | スマホ用のブラウザはWEBサイトからのいたずらを防ぐため、ユーザーが画面に触れるまでは音が出ない(音を溜めておく、みたいな)不便な制約があります。
          | なので初回だけ変なタイミングでまとめて音が出たりします。
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "ShareBoardHelpBody",
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
.ShareBoardHelpBody
  // .b-tabs
  //   .tab-content
  //     padding: 1.5rem
  padding: 1.5rem
  article
    &:not(:first-child)
      margin-top: 2rem
    h2
      font-size: $size-4
      font-weight: bold
    // h2 > p
    //   margin-top: 0.5rem
    .article_body
      margin-left: 1rem
</style>
