export const Xdelay = {
  // setTimeout のラッパーではない
  //
  // seconds < 0:  実行しない
  // seconds == 0: 即座に実行
  // seconds > 0:  seconds秒待って実行
  //
  delay_block(seconds, block) {
    if (seconds < 0) {
      return null
    }
    if (seconds === 0) {
      block()
      return null
    }
    return setTimeout(block, 1000 * seconds)
  },

  delay_stop(delay_id) {
    if (delay_id) {
      clearTimeout(delay_id)
    }
  },

  ////////////////////////////////////////////////////////////////////////////////

  // あとで実行する
  // だいたい 4ms 後に実行
  // これで他のイベントを先に動かせる
  callback_later(block) {
    return setTimeout(block, 0)
  },
}
