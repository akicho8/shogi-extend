// ▼音声を連続で鳴らしていくには？
//
//   const audio_queue = new AudioQueue()
//   audio_queue.media_push(response.data.service_path)
//
// ▼なぜ「CPU対局」直リンすると挨拶が再生されないのか？
//
//   何のイベントにもひっかかってないため play()  で次のエラーになる
//   > Uncaught (in promise) DOMException: play() failed because the user didn't interact with the document first. https://goo.gl/xX8pDD
//   だけど駒を一回触ったときに、こっそり入れた click または touchstart が発動するため次からの指し手は発声できる
//   なお chrome://flags/#autoplay-policy で No user gesture is required にすると回避できるが、もちろん利用者の設定をこちらから変更することはできない
//

import no_sound from "./no_sound.mp3" // 自動再生制限を解除するための無音

class AudioQueue {
  constructor() {
    this.audio = new Audio()    // 全体で一箇所だけにすること(スマホで解除されるのはそのタイミングのインスタンスだけなため)
    this.queue = []

    // 最初の音声が終わったタイミングで次の音声を発声していく
    this.audio.addEventListener("ended", () => this.play_next(), false)

    // スマホはタッチイベントのタイミングでしか音をならせないためこっそり解除する
    document.addEventListener("touchstart", () => this.media_push(no_sound), {once: true})
    document.addEventListener("click",      () => this.media_push(no_sound), {once: true})
  }

  media_push(media_file) {
    this.queue.push(media_file)
    console.log(`push:${media_file} paused:${this.audio.paused} currentTime:${this.audio.currentTime} ended:${this.audio.ended}`)
    this.play_next()
  }

  play_next() {
    if (this.audio.ended || this.audio.currentTime === 0) { // TODO: 発声中かどうかのもっと簡単なメソッドはないのか？
      if (this.queue.length >= 1) {
        this.audio.src = this.queue.shift()
        const play_resp = this.audio.play()
        if (false) {
          play_resp.catch(e => alert(e))
        }
        console.log(`play:${this.audio.src}`)
      }
    }
  }
}

// グローバル変数にしないといけない
// var で定義するとグローバルにならない
window.audio_queue = new AudioQueue()
