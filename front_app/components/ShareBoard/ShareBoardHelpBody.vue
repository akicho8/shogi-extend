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
        ol
          li 「部屋に入る」を選択し「合言葉」と「ハンドルネーム」を入力して入室
          li
            | 同じ合言葉を他の仲間にも伝えて同様に入室してもらう<br>
            | このとき「合言葉だけを含むURL」を伝えると、伝えられた側はサイトに来て入力する手間を省略できる
          li 必要であれば「手合割」を設定する
          li 「順番設定」する
          li 「時計設定」する
          li 後手または上手の人は☗か☖をタップして反転する
          li 順番に指していく
          li 何か伝えたいことがあれば右上のメッセージボタンから発言する
          li 「反則の取り消し」や「待った」は合意を得た上で「1手戻す」で指し直す
          li 投了は右上のメッセージボタンから発言する
          li 対局終了後は時計を停止する (盤の下のコントローラーが表示される)
          li 対局終了後に検討する場合は「順番設定」を解除する (自由に駒を動かせるようにするため)
          li 再度対局するには「初期配置に戻す」を実行する

    article
      h2 ツイッターを利用したリレー将棋
      .article_body
        p
          | グループ内で順番に指してツイートを繰り返す方式
        ol
          li 「ツイート画像の視点設定」を「1手指し継いだとき自分の視点」に変更する (初回のみ)
          li メニューの「タイトル変更」で任意のタイトルに変更する (初回のみ)
          li 1手指す
          li ツイートボタンからツイートして次の人を指名する
        p
          | 指し手の情報はすべてURLに含まれるので、指名されていない人が盤を動かしても、指名された人が指す局面には影響ない。

    article
      h2 対面でリアル対戦
      .article_body
        p
          | スマホをテーブルに置いて二人で向かいあって指す方式。そのまま指す。上下対称。
        ol
          li 必要であれば「手合割」をする
          li 必要であれば「時間設定」する
          li そのまま指す

    article
      h2 課題局面や詰将棋の作成と公開
      .article_body
        ol
          li 「局面編集」から任意の局面を作成
          li ツイートボタンからツイート

    article
      h2 盤を反転するには？
      .article_body
        p ☗または☖をタップ

    article
      h2 いまどちらの手番？
      .article_body
        p ☗または☖の大きい方

    article
      h2 ときどき牛が鳴くのはなぜ？
      .article_body
        p あなたの手番を知らせている

    article
      h2 駒を成る操作を間違えてしまう
      .article_body
        p 駒を移動した場所に「成り」の選択が来るようにしている。
        p つまり「成り」は「ダブルタップ」。

    article
      h2 盤が同期してなくない？
      .article_body
        p
          | 次の操作をしたときだけ同期する
        ul
          li 新しい手を指した
          li 「初期配置に戻す」を実行
          li 「1手戻す」を実行
          li 「局面の転送」を実行
          li 「手合割」を適用
        p
          | 盤の下のコントローラーを動かしたときの局面変化は自分の盤だけ

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
      h2 盤の下のコントローラーがなくなった？
      .article_body
        p
          | 対局中に間違えて押して動転してしまう人がいるため、デフォルトでは時計が動いている間は消している。
          | 「設定」から常に表示するようにできる。

    article
      h2 リレー将棋対局後に棋譜を関係者に公開するには？
      .article_body
        ul
          li 棋譜だけを含むURLのコピー
          li 棋譜コピー
        p
          | URLだと棋譜再生用のアプリがなくてもタップするだけで確認できる

    article
      h2 再戦するには？
      .article_body
        p
          | 「初期配置」に戻す。
          | これは初手を指す人がコントローラーの左ボタンで0手目に戻すのとほぼ同じ。

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
          | リアル将棋と同じで対戦者同士で判断

    article
      h2 トライルールはある？
      .article_body
        p
          | あらかじめ対戦者同士で決めておく

    article
      h2 反則したけど指し直していいと言われたら？
      .article_body
        ol
          li 「1手戻す」を選択
          li 合法手を指す

    article
      h2 スマホで音が出なくなることがある
      .article_body
        ul
          li
            | 裏で同時に動いているアプリすべて終了
            | メニューの「再起動」を実行

        | 詳しい原因はわかっていないが上の操作で直ることがある

    article
      h2 最初に画面に触れたとたん変なタイミングで音が出た
      .article_body
        p
          | 一般的なWEBブラウザはユーザーが操作するまでは音が出ないので
          | 最初に画面に触れたタイミングでまとめて音が出たりする
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
      font-size: $size-5
      font-weight: bold
    // h2 > p
    //   margin-top: 0.5rem
    .article_body
      margin-left: 1rem
</style>
