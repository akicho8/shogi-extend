<template lang="pug">
.ShareBoardHelpBody
  //- b-tabs(v-model="tab_index")
  //-   b-tab-item(label="使い方")
  //- b-tab-item(label="FAQ")
  //-   .content
  .content
    article
      h2 リアルタイムなリレー将棋をするには？
      .article_body
        b 準備
        ol.mt-2
          li 「部屋に入る」を選択
          li 「合言葉」と「ハンドルネーム」を入力して「入室」
          li 同じ合言葉を仲間に伝えて入室を促す
          //- | このとき「部屋のリンク」を伝えると、伝えられた側はサイトに来て入力する手間を省略できる
          li みんな揃うのを待つ
          li 「順番設定」する
          li 「時計設定」する
          li 手番の人から指していく

        b 対局中
        ol.mt-2
          li 「待った」は合意を得た上で「1手戻す」で指し直す
          li 投了は右上のメッセージボタンから発言する

        b 対局後
        ol.mt-2
          li 時計を止める
          li 「順番設定」を解除する

        b 再度対局
        ol.mt-2
          li 「初期配置に戻す」を実行
          li 「順番設定」する
          li 「時計設定」する
          li 手番の人から指していく

    article
      h2 ツイッターを利用したリレー将棋をするには？
      .article_body
        p
          | グループ内で順番に指してツイートを繰り返す方式
        b 準備
        ol.mt-2
          li 「ツイート画像の視点設定」を「1手指し継いだとき自分の視点」に変更
          li 「タイトル変更」で任意のタイトルに変更
        b 繰り返し
        ol.mt-2
          li 1手指す
          li ツイートボタンからツイートして次の人を指名する
        p
          | 指し手の情報はすべてURLに含まれるので、指名されていない人が盤を動かしても、指名された人が指す局面には影響ない

    article
      h2 対面でリアル対戦するには？
      .article_body
        p
          | スマホをテーブルに置いて二人で向かいあって指す方式。そのまま指す。上下対称。
        ol
          li 必要であれば「手合割」をする
          li 必要であれば「時間設定」する
          li そのまま指す

    article
      h2 課題局面や詰将棋の作成と公開をするには？
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
      h2 ときどき牛が鳴くのは？
      .article_body
        p あなたの手番を知らせている

    article
      h2 ときどき犬が吠えるのは？
      .article_body
        p 誰かの入室を知らせている

    article
      h2 ニワトリが鳴くのは？
      .article_body
        p 対局の開始を伝えている

    article
      h2 アバターありにするとどうなる？
      .article_body
        ul
          li ログインしていると自分のプロフィール画像が玉になる
          //- li ログインしていないとなんかしらの絵文字が玉になる

    article
      h2 シャウトありにするとどうなる？
      .article_body
        p 駒が動くときに叫ぶ

    article
      h2 ニワトリが鳴くのは？
      .article_body
        p 対局の開始を伝えている

    article
      h2 駒を成る操作を間違えてしまう
      .article_body
        p 移動先に「成る」の選択が来るようにしているのでダブルタップと覚える

    article
      h2 局面を動かしたけど同期してなくない？
      .article_body
        ul
          li 盤の下のコントローラーで局面を動かしたときの変化は自分の画面だけ
          li 相手にも見せたいときは「局面の転送」を実行する

    article
      h2 盤はどのタイミングで同期する？ (重要)
      .article_body
        ul
          li 新しい手を指した
          li 「初期配置に戻す」を実行
          li 「1手戻す」を実行
          li 「局面の転送」を実行
          li 「手合割」を適用

    article
      h2 ハンドルネームを変更するには？
      .article_body
        ul
          li 「ハンドルネームを変更」を選択 (対局前のみ)
          li または「部屋に入る」を選択 (対局中であればいったん「退室」)
        p
          | 順番設定後の変更は再度順番設定が必要になるためころころ変更しない方がよい

    article
      h2 上書きしてしまった棋譜を本筋に戻すには？
      .article_body
        ul
          li 右側の履歴に駒を動かす前の指し手があればそれをタップする
          li 対局終了のタイミングは基本的に「時計停止」なのでそれを目印にするとよい

    article
      h2 盤の下のコントローラーが表示されなくなった？
      .article_body
        ul
          li 時計が動いている間は消している<br>（対局中に間違えて押す人がいるため）
          li 時計を「取り除く」か「停止」か「一時停止」にすると表示する
          li 「設定」から常に表示するようにできる

    article
      h2 リレー将棋対局後に棋譜を関係者に公開するには？
      .article_body
        ul
          li 棋譜だけを含むURLのコピー
          li 棋譜コピー
        p
          | URLだとタップするだけで確認できる

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
          | ない。あらかじめ対戦者同士で決めておく

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
          | 「牛」と「次は○○の手番」の発声は順番設定の面子が3人以上のときだけとしている。2人以下では順番が明確なため。

    article
      h2 時計の設定値の意味は？
      .article_body
        table.table
          tr
            th 持ち時間(分)
            td 最初に減っていく。1手毎に「1手毎加算」だけ回復する
          tr
            th 秒読み(秒)
            td 「持ち時間」が0になったあとで減っていく。<b>回復する</b>。0になっても猶予が残っていれば即負けにはならない
          tr
            th 猶予(秒)
            td 秒読みが0になったあとで減っていく。<b>回復しない</b>。0になると負け
          tr
            th 1手毎加算(秒)
            td 1手指すごとに「持ち時間」に加算する秒数。固定値なので変動しない。これを設定するときは「秒読み」「猶予」は設定しないほうがよい。設定するとややこしくなる。

    article
      h2 ログイン不要のメリットとデメリット
      .article_body
        p
          | メリット → ログインしなくてよい
        p
          | デメリット → ハンドルネームが衝突すると同じアカウントと見なされるため順番設定がまともに機能しなくなる。例えば4人で対局したくても名前が被っていると順番設定では3人になる

    article
      h2 棋譜コピーしただけでみんなに通知されたのはなぜ？
      .article_body
        p ソフト指しの疑念を生まないようにするため

    article
      h2 検討したいのに駒が動かないんだが？
      .article_body
        p 手番制限が効いているため順番設定を解除する

    article
      h2 棋譜読み込み後に駒を動かして読み込んだ棋譜を上書きしてしまった
      .article_body
        p 右の履歴の「棋譜読込後」をタップすると読み込んだ直後の棋譜に復帰する

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
      margin-top: 2.5rem
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
