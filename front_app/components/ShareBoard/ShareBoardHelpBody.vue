<template lang="pug">
.ShareBoardHelpBody
  //- b-tabs(v-model="tab_index")
  //-   b-tab-item(label="使い方")
  //- b-tab-item(label="FAQ")
  //-   .content
  .content
    article
      h2 リアルタイムなリレー将棋
      .article_body
        ol
          li 「部屋に入る」を選択し「合言葉」と「ハンドルネーム」を入力して入室
          li
            | 同じ合言葉を他の仲間にも伝えて同様に入室してもらう<br>
            | このとき「合言葉だけを含むURL」を伝えると、伝えられた側はサイトに来て入力する手間を省略できる
          li みんな揃ったところで、必要であれば「手合割」を設定する
          li 「順番設定」する
          li 「時計設定」する
          li 順番に指していく
          li 「反則の取り消し」や「待った」は合意を得た上で「1手戻す」で指し直す
          li 投了は右上のメッセージボタンから発言する
          li (対局終了後) 時計停止する
          li 検討する場合は「順番設定」を解除する。これで自由に駒を動かせるようになる
          li 再度対局するには「初期配置に戻す」を実行する

    article
      h2 ツイッターを利用したリレー将棋
      .article_body
        p
          | グループ内で順番に指してツイートを繰り返す方式
        ol
          li (初回のみ)「ツイート画像の視点設定」を「1手指し継いだとき自分の視点」に変更する 
          li (初回のみ) メニューの「タイトル変更」で任意のタイトルに変更する 
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
      h2 ときどき犬が吠えるのはなぜ？
      .article_body
        p 誰かの入室を知らせている

    article
      h2 ニワトリが鳴いたのは？
      .article_body
        p 対局の開始を伝えている

    article
      h2 駒を成る操作を間違えてしまう
      .article_body
        p 移動先に「成る」の選択が来るようにしているのでダブルタップと覚える

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
          | 盤の下のコントローラーを動かしたときの局面変化は自分の盤だけなので注意。相手にも見せたいときは「局面の転送」を実行する。

    article
      h2 ハンドルネームを変更するには？
      .article_body
        ul
          li 「部屋に入る」から「退室」
          li または「ハンドルネームを変更」を選択
        p
          | 順番設定後に変更すると再度順番設定が必要になるため、ころころ変更しない方がよい

    article
      h2 上書きしてしまった棋譜を本筋に戻すには？
      .article_body
        ul
          li 右側の履歴に駒を動かす前の指し手があればそれをタップする
          li 対局終了のタイミングは基本的に「時計停止」なのでそれを目印にするとよい

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
          | URLだと棋譜再生用のアプリがなくてもタップするだけで確認できるのでおすすめ

    article
      h2 再戦するには？
      .article_body
        p
          | 「初期配置に戻す」を選択。
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
      h2 スマホで音が出なくなった
      .article_body
        ul
          li 裏で同時に動いているアプリすべて終了
          li メニューの「再起動」を実行
        p
          | 詳しい原因はわかっていないが上の操作で直る場合がある

    article
      h2 変なタイミングで音が出た
      .article_body
        p
          | 一般的なWEBブラウザはユーザーが画面に触れるまでは音が出ないので、
          | 最初に画面に触れたタイミングでまとめて音が出たりする。これは仕方がない。

    article
      h2 牛が鳴かないときがある
      .article_body
        p
          | 「牛」と「次は○○の手番」の発声は順番設定の面子が3人以上のときだけ

    article
      h2 時計の設定値の意味は？
      .article_body
        table.table
          tr
            th 持ち時間(分)
            td 最初に減っていく。1手毎に「1手毎加算」だけ回復する
          tr
            th 秒読み(秒)
            td 「持ち時間」が0になったあとで減っていく。回復する。0になっても猶予が残っていれば即負けにはならない
          tr
            th 猶予(秒)
            td 秒読みが0になったあとで減っていく。<b>回復しない</b>。0になると負け
          tr
            th 1手毎加算(秒)
            td 1手指すごとに「持ち時間」に加算する秒数。固定値なので変動しない。これを設定するときは「秒読み」「猶予」は設定しないほうがよい (設定すると混乱する)

    article
      h2 ログイン不要のメリットとデメリット
      .article_body
        p
          | メリット → ログインしなくてよい
        p
          | デメリット → ハンドルネームが衝突すると同じアカウントと見なされるため順番設定がまともに機能しなくなる。例えば4人で対局したくても名前が被っていると順番設定では3人しか設定でできな

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
      th
        white-space: nowrap
</style>
