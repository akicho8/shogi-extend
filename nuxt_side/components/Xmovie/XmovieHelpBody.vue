<template lang="pug">
.XmovieHelpBody.is_line_break_on
  .content
    article
      h2 簡単な使い方
      .article_body
        ol
          li 棋譜を貼る
          li 「実行」をタップ
          li 待つ
          li ダウンロードする

    article
      h2 待ちきれない
      .article_body
        | 終わったらメールするので待たなくてもいい

    article
      h2 出来たファイルに直リンしていい？
      .article_body
        p 容量の関係で古いのは消すこともあるのでなるべくダウンロードしてほしい

    article
      h2 あらかじめ動画の長さを求めるには？
      .article_body
        .content
          p
            code 1手の秒数 * (1 + 手数) + 最後に停止する秒数
            | で動画の長さが求まる。
          p
            | 手数に1を足しているのは初期配置の局面を追加しているから。
            | (表紙がある場合はさらに +1 する)
          p
            | なので動画の長さから最長手数を逆算するときは、
            ul
              li 2分20秒の動画
              li 最後に7秒停止する
              li 1手1秒
            | なので
            code (2分20秒 - 7秒) / 1秒 - 1
            | として 132 手までいけることがわかる

    article
      h2 動画から棋譜に変換するには？
      .article_body
        | メタデータにSFEN形式の棋譜を入れてあるので ffprobe に読ませたり、
        a.mx-1(href="https://mediaarea.net/MediaInfoOnline" target="_blank") https://mediaarea.net/MediaInfoOnline
        | にアップロードして内容を取得し、「なんでも棋譜変換」等に投げる

    article
      h2 曲にハメるには？
      .article_body
        | 2拍で1手指すとき
        ul
          li 1手1秒だと 120BPM の曲に合わせるとはまる
          li 1手0.9秒だと 108BPM の曲に合わせるとはまる
        | つまり
        code 1手の秒数 * 120
        | ではまる BPM がわかる
        pre
          | 1.1 * 120 = 132 BPM
          | 1.0 * 120 = 120 BPM
          | 0.9 * 120 = 108 BPM
        | 逆に BPM にハメる1手の秒数を求めるには
        code BPM / 120
        | とする
        pre
          | 130 / 120 = 1.083 s
          | 120 / 120 = 1.0 s
          | 110 / 120 = 0.917 s
        | この計算は自分でやらなくても <b>BPM</b> ボタンで BPM から秒に変換できる

    article
      h2 1手N秒入力欄の下のBPMについて
      .article_body
        ul
          li 2拍(2分音符)毎に1手指すのを想定したBPMを表示している
          li 1拍(4分音符)や4拍(全音符)毎に指すときは <b>×2</b> や <b>÷2</b> で調整する

    article(v-if="development_p")
      h2 Twitterのアップロード条件について
      .article_body
        | 公表しないまま仕様が変わったり、「推奨」と書かれているだけだったりで実際どの閾値で失敗・成功するのかはよくわかっていない

    article(v-if="development_p")
      h2 動画じゃなくて別の棋譜フォーマットにするには？
      .article_body
        | 「なんでも棋譜変換」を使う。
        | 棋譜入力欄の「棋譜変換」から飛べる。

    article(v-if="development_p")
      h2 どういう内容の棋譜だったか事前に確認するには？
      .article_body
        | 「共有将棋盤」を使う。
        | 棋譜入力欄の「将棋盤」から飛べる。

    article
      h2 ここに載ってない
      .article_body
        p
          | →
          a.mx-1(href="https://twitter.com/sgkinakomochi") @sgkinakomochi
</template>

<script>

export default {
  name: "XmovieHelpBody",
}
</script>

<style lang="sass">
@import "support.sass"
.XmovieHelpBody
  padding: 1.5rem
  article
    &:not(:first-child)
      margin-top: 2.5rem
    h2
      font-size: $size-5
      font-weight: bold
    .article_body
      margin-left: 1rem
      th
        white-space: nowrap
    pre
      margin-top: 0.75rem
</style>
