<template lang="pug">
.XmovieHelpBody
  .content
    article
      h2 どうやって使う？
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
      h2 出来たファイルを直リンしていい？
      .article_body
        p 定期的に古いのは削除するので直リンしない方が良い

    article
      h2 Twitterのアップロード条件は本当？
      .article_body
        | 正確とは限らない。Twitter側の条件は公表しないまま変わっているようなので結果に関係なくアップロードできたりできなかったりする。

    article
      h2 動画じゃなくて別の棋譜フォーマットにするには？
      .article_body
        | 「なんでも棋譜変換」を使う。
        | 棋譜入力欄の「棋譜変換」から飛べる。

    article
      h2 どういう内容の棋譜だったか事前に確認するには？
      .article_body
        | 「共有将棋盤」を使う。
        | 棋譜入力欄の「将棋盤」から飛べる。

    article(v-if="development_p")
      h2 分割するには？
      .article_body
        | https://kakashibata.hatenablog.jp/entry/2018/11/25/155437
        | ffmpeg -i input.mp4 -f image2 -start_number 0 -y %04d.png

    article(v-if="development_p")
      h2 連番画像から自分で動画化するには？
      .article_body
        | ffmpeg -hide_banner -framerate 1 -i %d.png -vcodec libx264 -pix_fmt yuv420p -r 1 -y _output.mp4

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
</style>
