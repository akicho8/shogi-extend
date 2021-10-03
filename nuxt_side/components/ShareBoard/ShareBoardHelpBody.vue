<template lang="pug">
.ShareBoardHelpBody
  .content
    article
      h2 対局するには？
      .article_body
        ol.mt-2
          li 部屋を立てて部屋のURLを仲間に伝える
          li 順番設定で順番を決める
          li 対局時計を設置して開始

    article
      h2 対局するには？ (詳細)
      .article_body
        b 準備
        ol.mt-2
          li
            | 部屋に入る
            ul.mt-1
              li 「合言葉」と「ハンドルネーム」を入力して「入室」
              li 同じ合言葉を入力した人同士で部屋を共有する
              li 合言葉が単純だと干渉する場合がある
              li 仲間には「部屋のリンク」を伝えるのがおすすめ
              li 伝えられた側は合言葉を入力する手間を省略できる
          //- li
          //-   | 相手を呼んでくる
          //-   ul.mt-1
          //- li
          //-   | 相手が来るのを待つ
          //-   ul.mt-1
          //-     li 待ってる間に「手合割」や「対局時計」の設定をしても良い
          //- li
          //-   | 必要であれば「手合割」をする
          //-   ul.mt-1
          //-     li だいたい手合割はしない
          li
            | 順番設定
            ul.mt-1
              li 有効にした時点で居るメンバー全員参加になる
              li 棋力が偏ってたら「シャッフル」や「↓」「↑」で調整する
              li 観戦をしに来ただけの人がいたら「OK」を「観戦」に変更する
              li 奇数人でやってもいいけど1周する度に<b>先後がずれる</b>
          li
            | 対局時計
            ul.mt-1
              li
                b-icon(icon="play" size="is-small")
                | で開始
              li ニワトリが鳴くので手番の人から指していく

        b 対局中
        ul.mt-2
          li 投了は右上の吹き出しボタンから発言する
          li
            | 自分の手番がわからなくなったら「牛」の鳴き声を合図に指す
            ul.mt-1
              li メンバーリストの番号でも手番を確認できる
          li
            | 時間切れにならないように指す
            ul.mt-1
              li 切れても「秒読み」等の回復要素があれば続行できる
              li しかし何度もやると顰蹙を買う
          li
            | 「待った」は「1手戻す」で指し直す
            ul.mt-1
              li 合意を得た上でやらないとこれも顰蹙を買う
              li 普通はお情けで相手が1手戻してくれることが多い

        b 対局後
        ol.mt-2
          li 時計を止める
          li
            | <b>順番設定を解除</b>する
            ul.mt-1
              li 解除すると誰でも駒を動かせる状態に戻る
              li したければみんなで盤を動かして検討する
          li
            | 他のアプリで検討する場合は「棋譜コピー」
            ul.mt-1
              li 「ぴよ将棋」や「KENTO」の場合は直接メニューから起動する
          li
            | チャットアプリ等に棋譜を貼る場合
            ul.mt-1
              li
                | 「棋譜リンクコピー」して貼る
                ul.mt-1
                  li ブラウザのURLでは部屋への誘導になってしまう
              li
                | 検討中で本筋を上書きしてしまっている場合
                ol.mt-1
                  li 指し手の履歴から「時計停止」を含む行をタップ
                  li その中の「リンク」をタップ
                  li これが対局終了時点の棋譜になっている
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
            ul.mt-1
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
      h2 投了するには？
      .article_body
        p 右上の吹き出しアイコンからリアル対局と同様に自分の言葉で伝える

    article
      h2 リレー将棋で手番を間違えて指してしまう
      .article_body
        p 順番設定する

    article
      h2 リレー将棋で観戦者が指した
      .article_body
        p 順番設定する

    article
      h2 通信環境が不安定で指し手が正確に伝わらない
      .article_body
        p 順番設定する

    article
      h2 検討したいのに駒が動かないんだが？
      .article_body
        p 「順番設定」を解除する

    article
      h2 部屋のリンクを伝えるには？
      .article_body
        ol
          li 「部屋に入る」の中にある「部屋のリンク」
          li またはメニュー内の「部屋のリンクのコピー」をタップ
          li これで<b>部屋の合言葉だけ</b>が含まれるURLがクリップボードに入る
          li それをチャットツール等に貼る
        p
          | ブラウザのURLにも部屋の合言葉は入っているが、余計な情報(現在の盤面の情報)も含んでいるため、単に部屋のリンクを伝えるときは上の方法が良い

    article
      h2 反転するには？
      .article_body
        p
          | ☗または☖をタップ
        ul
          li 時計開始のタイミングで後手番は自動的に反転する
          li なので自分で反転するは必要はない
          li しかし途中から参加したのが後手番だったときには自分で反転する必要がある
          li 単にひふみんアイしたいときにも用いる

    article
      h2 いまどちらの手番？
      .article_body
        p ☗または☖の大きい方

    article
      h2 ニワトリが鳴くのは？
      .article_body
        p 対局の開始を伝えている

    article
      h2 牛が鳴くのは？
      .article_body
        p あなたの手番を知らせている

    article
      h2 犬が吠えるのは？
      .article_body
        p 誰かの入室を知らせている

    article
      h2 アバターありとは？
      .article_body
        p 自分のアイコン画像が玉になる (不評)
        ul
          li ログインしていないとなんかしらの動物が玉になる
          li 対象が2人以上の場合は順番が早い方をリーダーとみなす

    article
      h2 シャウトありとは？
      .article_body
        p 駒が動いたり殺されたとき無駄に叫ぶ (不評)

    article
      h2 リレー将棋を奇数人数で行うとどうなる？
      .article_body
        ul
          li 1周するたびに先後がずれる
          li とくに制限はしてない

    article
      h2 リレー将棋を1人で試すには？
      .article_body
        p 部屋を立てて1人で順番設定して時計を設置して始める。自分vs自分になる

    article
      h2 駒を成る操作を間違えてしまう
      .article_body
        p 移動先に「成る」の選択肢があるので単にダブルタップする

    article
      h2 再戦するには？
      .article_body
        p 「初期配置に戻す」
        //- ul
        //-   li これで全員の盤が0手目に戻る
        //- li 初手を指す人がコントローラーの左ボタンで0手目に戻してから1手目を指したときと状態は同じになるけど、いったん全員の盤を初期配置にした方がわかりやすい

    article
      h2 シャッフルとは？
      .article_body
        p 順番をランダムで決める

    article
      h2 振り駒とは？
      .article_body
        ul
          li 先後をランダムで決める
          li チーム編成は維持したまま
          li 誰が振るかには依存しない
          li 記録係が振り、すでに☗にいる人を上座と想定している
          li つまり歩が3枚以上ならそのまま
          li 「と金」が3枚以上なら先後を入れ替える
          li 実行は一瞬だが内部では実際に5枚の歩を10回から20回しゃかしゃかやっている

    article
      h2 先後入替とは？
      .article_body
        p 手動で先後を調整したいときに使う

    article
      h2 駒落ちで対戦するには？
      .article_body
        p 手合割

    article
      h2 手合割の選択肢に希望のものがないんだが？
      .article_body
        ol
          li 局面編集
          li 局面の転送

    article
      h2 二歩・王手放置・持将棋・千日手の判定は？
      .article_body
        p
          | プログラム側での判定は一切していない

    article
      h2 観戦者が二歩などの指摘をしてもいい？
      .article_body
        p
          | 主催者や審判があらかじめ禁止していなかったら指摘してよい。
          | 終局後の指摘でも有効になる。
        blockquote(cite="https://ja.wikipedia.org/wiki/%E4%BA%8C%E6%AD%A9")
          | 終局していた場合であっても、当該棋戦の次の対局が始まる前にその二歩の指摘があれば、遡って二歩をした側の反則負けとなる
          figcaption.has-text-right
            a(href="https://ja.wikipedia.org/wiki/%E4%BA%8C%E6%AD%A9" target="_blank")
              cite
                | Wikipedia - 二歩

    article
      h2 死に駒の制限はある？
      .article_body
        p
          | 11桂不成などの死に駒は作れないようにしている

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
      h2 盤の大きさを調整するには？
      .article_body
        ul
          li メニューの一番下にある「スタイル設定」で調整する
          li デフォルトでは若干小さめにしているので各自のディスプレイに合わせて調整してほしい

    article
      h2 局面を動かしたけど同期してなくない？
      .article_body
        ul
          li
            | 盤の下のコントローラーで局面を動かしたときは同期<b>しない</b>

          li 他者の盤も変更するには「局面の転送」を実行する

    article
      h2
        | 盤はどのタイミングで同期する？
        span.has-text-danger.mx-1 重要
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
      h2 盤の下のコントローラーが表示されなくなった？
      .article_body
        ul
          li 対局中に間違えて押して混乱する人がいるため時計動作中は消している
          li 時計を「取り除く」か「停止」か「一時停止」にすると表示する
          li 「設定」から常に表示するようにできる

    article
      h2 対局後に棋譜を関係者に公開するには？
      .article_body
        p 棋譜リンクコピー
        p 棋譜コピーでも良いがURLだとタップするだけで確認できる

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
          | 「牛」と「次は○○の手番」の発声は順番設定の面子が3人以上のときだけ。2人以下では順番が明確なので鳴かない。

    article
      h2 時計の値の意味は？
      .article_body
        table.table
          tr
            th 持ち時間(分)
            td
              | 最初に減っていく<br>
              | 1手毎に「1手毎加算」だけ回復する
          tr
            th 秒読み(秒)
            td
              | 「持ち時間」が0になると減っていく<br>
              | 1手毎に初期値まで<b>回復する</b><br>
          tr
            th 猶予(秒)
            td
              | 「秒読み」が0になると減っていく<br>
              | <b>回復しない</b><br>
              | 0になると負け
          tr
            th 1手毎加算(秒)
            td
              | フィッシャールール用の1手毎に「持ち時間」に加算する秒数<br>
              | この値だけは変動しない<br>
              | これを設定するときは分かりやすさのため「秒読み」「猶予」は設定しないほうがよい<br>

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
      h2 棋譜読み込み後に本筋を上書きしてしまった
      .article_body
        p 右の履歴の「棋譜読込後」をタップすると読み込んだ直後の棋譜に復帰する

    article
      h2 ハンドネームを変更すると全体のログイン名も変わる？
      .article_body
        ul
          li 変わらない
          li 共有将棋盤内のハンドルネームは共有将棋盤内だけの扱い
          li ハンドルネームの入力初期値がログイン名になっているというだけの関係

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
      h2 順番設定のメリットは？
      .article_body
        ul
          li
            | 手番間違い防止
            ul
              li 手番の人は指せなくなる
          li
            | 指し手の伝達が正確になる
            span.has-text-danger.mx-1.has-text-weight-bold 重要
            ul
              li 次の指し手がわかるので伝わったかを内部で検証するようになる

    article
      h2 たまに出る局面再送とは？
      .article_body
        ul
          li 指し手を正確に転送するための機能で、失敗を検知したときに出る
          li 通信不調などで自家は指したつもりになっているが下家はずっと待っているのような状態を防ぐ
          li 自家が下家に局面を転送したあと下家から応答がないと再送ダイアログを表示する
          li <b>順番設定しているときだけ</b>作動する

    article
      h2 同名の人が増殖している
      .article_body
        ul
          li きちんと退室せずに入り直したとき前の人がゾンビになる
          li プログラム側はゾンビと今の人が同じか区別できない
          li ゾンビは応答がないとそのうち抹殺される
          li
            | 順番設定は名前のみで決まるので同名のゾンビがいても無視してればよい
            ul
              li 同名のゾンビがいるからといってハンドルネームを変えると順番設定でゾンビを除外する手間がかかる

    article
      h2 ゾンビからの復活
      .article_body
        ul
          li ブラウザを閉じたり通信不調などで応答がないとゾンビ化する
          li ゾンビは抹殺されるまで猶予がある
          li その猶予内に応答すれば人に戻れる

    article
      h2 名前が薄い人がいる
      .article_body
        | 別の画面を見ている

    article
      h2 特定メンバーをBANしたい
      .article_body
        | そういう機能はない

    article
      h2 ログインするメリットは？
      .article_body
        ul
          li
            | アバターありにした場合に自分のプロフィール画像を玉をできる
            ul
              li つまり玉をカスタマイズできる
          li ハンドルネームの初期値がログインネームになる
          li いまのところ他にはないが基本ログインしている方を優待する

    article
      h2 部屋に知らない人が入ってきた
      .article_body
        ul
          li 単純な合言葉にしていると干渉する場合がある
          li 部屋のリンクをSNSなどに貼ると知らない人も来る

    article
      h2 相手の切れ負け判定が遅くない？
      .article_body
        ol
          li もともとは各自の対局時計で判定していたので遅延は無かった
          li しかし通信環境が悪い場合に各自で異なる切れ負け判定をしてしまう場合があった
          li それを防ぐため手番である当事者の時計だけで判定し全員に通知する方法に変更した
          li これによって誤判定はなくなった
          li しかし当事者から時間切れの通知が来なければ他者は時間切れになったことがわからなくなった
          li つまり速度を取れば不正確になり、正確性を取れば遅延することになった
          li 時間切れになる直前に当事者が切断すれば他者が待ち惚けをくらうのは避けたかった
          li なので他者もこれまで通り自分の時計で時間切れの判定は行うが猶予として30秒待つことにした
          //- 遅延の長さは CC_AUTO_TIME_LIMIT_DELAY に依存
          li したがって切れ負け判定まで最大30秒かかる

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
      // &:hover
      //   background-color: $white-ter
      th
        white-space: nowrap
</style>
