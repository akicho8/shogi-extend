<template lang="pug">
.ShareBoardHelpBody
  //- b-tabs(v-model="tab_index")
  //-   b-tab-item(label="使い方")
  //-     .content
  //-       | A
  //-   b-tab-item(label="FAQ")
  //-     .content
  //-       | B
  .content
    article
      h2 対局するには？
      .article_body
        b 準備
        ol.mt-2
          li
            | 部屋に入る
            ul.is-size-6.mt-1
              li 「合言葉」と「ハンドルネーム」を入力して「入室」
              li 同じ合言葉を入力した人同士で部屋を共有する
              li 合言葉はなんでもよいがありきたりだと干渉する場合がある
              li 仲間には「部屋のリンク」を伝えるのがおすすめ
              li 伝えられた側は合言葉を入力する手間を省略できる
          //- li
          //-   | 相手を呼んでくる
          //-   ul.is-size-6.mt-1
          //- li
          //-   | 相手が来るのを待つ
          //-   ul.is-size-6.mt-1
          //-     li 待ってる間に「手合割」や「対局時計」の設定をしても良い
          //- li
          //-   | 必要であれば「手合割」をする
          //-   ul.is-size-6.mt-1
          //-     li だいたい手合割はしない
          li
            | 順番設定
            ul.is-size-6.mt-1
              li 有効にした時点で居るメンバー全員参加になる
              li 棋力が偏ってたら「シャッフル」や「↓」「↑」で調整する
              li 観戦しに来ただけの人がいたら「OK」を「観戦」に変更する
              li 奇数人でやってもいいけど1周する度に先後がずれる
          li
            | 対局時計
            ul.is-size-6.mt-1
              li
                b-icon(icon="play" size="is-small")
                | で開始
              li ニワトリが鳴くので手番の人から指していく

        b 対局中
        ul.mt-2
          li 投了は右上のメッセージボタンから発言する
          li
            | 自分の手番がわからなくなったら「牛」の鳴き声を合図に指す
            ul.is-size-6.mt-1
              li メンバーリストの番号でも手番を確認できる
          li
            | 時間切れにならないように指す
            ul.is-size-6.mt-1
              li 切れても「秒読み」等の回復要素があれば続行できるが何度もやると顰蹙を買う
          li
            | 「待った」は「1手戻す」で指し直す
            ul.is-size-6.mt-1
              li 合意を得た上でやらないと顰蹙を買う
              li 普通は相手がお情けで1手戻してくれることが多い

        b 対局後
        ol.mt-2
          li 時計を止める
          li
            | 「順番設定」を解除する
            ul.is-size-6.mt-1
              li 解除するのは検討用に誰でも駒を動かせるようにするため
          li AIで検討する場合は「ぴよ将棋」等を起動する
          li
            | 対局に参加していないメンバーに棋譜を見せたいときは「棋譜リンクコピー」をタップしてチャットアプリ等に貼る
            ul.is-size-6.mt-1
              li もう検討が始まっていて本筋を上書きしてしまった場合は、操作履歴から「時計停止」をタップして表示したモーダル内の「リンク」をタップする

        b 再対局
        ol.mt-2
          li 「初期配置に戻す」
          li 「順番設定」
          li
            | 「対局時計」の
            b-icon(icon="play" size="is-small")
            | で開始

    article
      h2 もっと簡単に開始できない？
      .article_body
        p
          | 自動マッチングを使うと「部屋に入る」「順番設定」「時計設置」を自動化する。
          | が、逆に細かいことはできなくなる。

    article
      h2 リレー将棋をするには？
      .article_body
        | 3人以上で対局する

    article
      h2 ツイッターを利用して対局するには？
      .article_body
        p
          | グループ内で順番に指してツイートを繰り返す通信将棋などと呼ばれる方式
        b 準備
        ol.mt-2
          li 「ツイート画像の視点設定」を「1手指し継いだとき自分の視点」に変更
          li
            | 「タイトル変更」で任意のタイトルに変更
            ul.is-size-6.mt-1
              li このタイトルがハッシュタグになる

        b 繰り返し
        ol.mt-2
          li 1手指す
          li ツイートボタンからツイートして次の人を指名する
        p
          | 棋譜はすべてURLに含まれるので、指名されていない人がイタズラで盤を動かしても、指名された人が指す局面には影響がない

    article
      h2 対面で対局するには？
      .article_body
        p
          | 1つのスマホで向かい合って指す方式
        ol
          li 必要であれば「手合割」をする
          li 必要であれば「時間設定」する
          li そのまま指す

    article
      h2 詰将棋を作成するには？
      .article_body
        ol
          li 「局面編集」
          li ツイートボタンからツイート

    article
      h2 反転するには？
      .article_body
        p
          | ☗または☖をタップ<br>
        p
          | 時計を開始したタイミングで後手側だけ自動的に反転するので基本的に自分で操作するは必要はない。
          | が、途中から参加したのが後手番だったときには自分で反転する必要がある。
          | 単にひふみんアイしたいときにも用いる。

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
      h2 アバターありとは？
      .article_body
        ul
          li 自分のプロフィール画像が玉になる
          li ログインしていないとなんかしらの絵文字が玉になる

    article
      h2 シャウトありとは？
      .article_body
        p 駒が動いたり殺されたとき無駄に叫ぶ (不評)

    article
      h2 ニワトリが鳴くのは？
      .article_body
        p 対局の開始を伝えている

    article
      h2 駒を成る操作を間違えてしまう
      .article_body
        p 移動先に「成る」の選択が来るのでダブルタップを意識する

    article
      h2 局面を動かしたけど同期してなくない？
      .article_body
        ul
          li 盤の下のｺﾝﾄﾛｰﾗｰで局面を動かしたときの変化は自分の画面だけ
          li 他者の盤も変更するには「局面の転送」を実行する

    article
      h2 盤はどのタイミングで同期する？ (重要)
      .article_body
        ul
          li 着手した瞬間
          li 「初期配置に戻す」実行
          li 「1手戻す」実行
          li 「局面の転送」実行
          li 「手合割」適用

    article
      h2 ハンドルネームを変更するには？
      .article_body
        ul
          li 対局前であれば「ハンドルネームを変更」
          li または「部屋に入る」 で対局中であればいったん「退室」
        p
          | 順番設定後の変更は再度順番設定が必要になるため変更しない方がよい

    article
      h2 上書きしてしまった棋譜を本筋に戻すには？
      .article_body
        ul
          li 右側の履歴に駒を動かす前の指し手があればそれをタップする
          li 対局終了のタイミングは基本的に「時計停止」なのでそれが目印

    article
      h2 盤の下のｺﾝﾄﾛｰﾗｰが表示されなくなった？
      .article_body
        ul
          li 対局中に間違えて押して混乱する人がいるため時計動作中は消している
          li 時計を「取り除く」か「停止」か「一時停止」にすると表示する
          li 「設定」から常に表示するようにできる

    article
      h2 対局後に棋譜を関係者に公開するには？
      .article_body
        ul
          li 「棋譜リンクコピー」
        p
          | 「棋譜コピー」でも良いがURLだとタップするだけで確認できる

    article
      h2 再戦するには？
      .article_body
        ul
          li 「初期配置に戻す」
          li これで全員の盤が0手目に戻る
        p
          | 初手を指す人がｺﾝﾄﾛｰﾗｰの左ボタンで0手目に戻してから1手目を指したときと状態は同じになる

    article
      h2 駒落ちで対戦するには？
      .article_body
        ul
          li 「手合割」

    article
      h2 手合割のプリセットに希望のものがないんだが？
      .article_body
        ol
          li 「局面編集」
          li 「局面の転送」

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
      h2 反則したけど指し直していいとだけ言われたら？
      .article_body
        ol
          li 「1手戻す」
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
          | 「牛」と「次は○○の手番」の発声は順番設定の面子が3人以上のときだけ。2人以下では順番が明確なため。

    article
      h2 時計の値の意味は？
      .article_body
        table.table
          tr
            th 持ち時間(分)
            td 最初に減っていく。1手毎に「1手毎加算」だけ回復する
          tr
            th 秒読み(秒)
            td 「持ち時間」が0になると減っていく。1手毎に初期値まで<b>回復する</b>。0になっても猶予が残っていれば即負けにはならない
          tr
            th 猶予(秒)
            td 「秒読み」が0になると減っていく。<b>回復しない</b>。0になると負け
          tr
            th 1手毎加算(秒)
            td 1手指すごとに「持ち時間」に加算する秒数。固定値なので変動しない。これを設定するときは「秒読み」「猶予」は設定しないほうがよい。設定するとややこしくなる。

    article(v-if="development_p")
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
        ul
          li 対局が終わっているのに「順番設定」をしたままなのが原因
          li 「順番設定」を解除する

    article
      h2 棋譜読み込み後に本筋を上書きしてしまった
      .article_body
        p 右の履歴の「棋譜読込後」をタップすると読み込んだ直後の棋譜に復帰する

    article
      h2 ハンドネームを変更するとログインネームも変わる？
      .article_body
        ul
          li 変わらない
          li 共有将棋盤内のハンドルネームは共有将棋盤内だけの扱い
          li ハンドルネームの初期値がログインネームになっているというだけ

    article
      h2 観戦するには？
      .article_body
        ul
          li 順番設定後に入ると自動的に観戦者になる
          li 対局者が観戦に移行するには順番設定で「OK」から「観戦」に変更する

    article
      h2 途中から参加するには？
      .article_body
        p 順番設定で「観戦」を「OK」に変更する

    article
      h2 たまに出る局面再送とは？
      .article_body
        ul
          li 指し手を正確に転送するための機能
          li 通信不調などで自家は指したつもりになっているが下家はずっと待っているのような状態を防ぐ
          li 自家が下家に局面を転送したあと下家から応答がないと再送ダイアログを表示する
          li 順番設定しているときだけ動作する

    article
      h2 ログインするメリットは？
      .article_body
        ul
          li アバターありにした場合に自分のプロフィール画像を玉をできる
          li ハンドルネームの初期値がログインネームになる
          li 他にはないが基本ログインしているほうが何かしら便利になる

    article
      h2 部屋に知らない人が入ってきた
      .article_body
        ul
          li 単純な合言葉にしていると干渉する場合がある
          li 部屋のリンクをSNSなどに貼ると知らない人も来る

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
