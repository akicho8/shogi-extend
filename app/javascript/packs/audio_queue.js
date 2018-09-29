// 音声を連続で鳴らしていく
//
// const audio_queue = new AudioQueue()
// audio_queue.media_push(response.data.service_path)

import no_sound from "./no_sound.mp3"

class AudioQueue {
  constructor() {
    this.audio = new Audio()    // 全体で一箇所だけにすること(スマホで解除されるのはそのタイミングのインスタンスだけなため)
    this.standby_mode = true
    this.queue = []

    // 最初の音声が終わったタイミングで次の音声を発声していく
    this.audio.addEventListener("ended", () => {
      if (this.queue.length === 0) {
        this.standby_mode = true
      } else {
        this.play_next()
      }
    }, false)

    // スマホはタッチイベントのタイミングでしか音をならせないため1回目で解除する
    // しかし画面をタッチしてくれるまでは音が出ない問題はある
    document.addEventListener("touchstart", () => this.media_push(no_sound)) // 1回だけ実行する
  }

  media_push(media_file) {
    this.queue.push(media_file)
    if (this.standby_mode) {
      this.play_next()
    }
  }

  play_next() {
    if (this.queue.length >= 1) {
      this.standby_mode = false
      this.audio.src = this.queue.shift()
      this.audio.play()
    }
  }
}

// こうするとグローバル変数にできる
// var で定義するとグローバルにはなってない
window.audio_queue = new AudioQueue()
