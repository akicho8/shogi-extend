<template lang="pug">
.ShareBoardHelpBody
  //- b-tabs(v-model="tab_index")
  //-   b-tab-item(label="使い方")
  //- b-tab-item(label="FAQ")
  //-   .content
  .content
    article
      h2 ツイッターを利用したリレー将棋
      p
        | 1手指してツイートを繰り返す方式です。通信将棋とも言われます。ツイート時には次に指す人を指名します。
      ol
        li
          | (初回のみ) 「共有将棋盤」をタップして任意のタイトルに変更する。<br>
          | このタイトルがツイート時のタグになる
        li (初回のみ) 「ツイート画像の視点設定」を「1手指し継いだとき自分の視点」に変更しておく
        li 1手指す
        li 盤の下のツイートボタンからツイート
    article
      h2 リアルタイムなペア将棋
      p
        | リアルタイムに複数人同士で対戦する方式です。いろいろセルフサービス的なところがあります。
      ol
        li 「部屋に入る」で「合言葉」と「ハンドルネーム」を入力して入室する
        li 設定した合言葉を他の仲間にも伝えて同様に入室してもらう
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
      h2 課題局面や詰将棋の作成と公開
      ol
        li 「局面編集」から任意の局面を作成
        li 盤の下のツイートボタンからツイート

    article
      h2 盤が同期してなくない？
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
      ul
        li メニューの「部屋に入る」から「退室」
      p
        | 順番設定後に変更すると再度順番設定が必要になる

    article
      h2 上書きしてしまった棋譜を本筋に戻すには？
      p
        | 右側の履歴に駒を動かす前の指し手があればそれをタップする
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
</style>
