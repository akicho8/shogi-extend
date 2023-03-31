import { Xinteger } from "./xinteger.js"

export const Xaratio = {
  // 片方を1に正規化した比率
  //
  //  100 : 50 = x : 1
  //  50x = 100
  //  x = 100 / 50
  //  x = 2
  //  ↓
  //  a : b = x : 1
  //  bx = a
  //  x = a / b
  //
  aspect_ratio_normalize(w, h) {
    w = w || 0
    h = h || 0
    if (w === 0 || h === 0) {
      return
    }
    if (w >= h) {
      w = w / h
      h = 1
    } else {
      h = h / w
      w = 1
    }
    return [w, h]
  },

  // 人間向け表記の比率
  // 片方を1にするのではなく 4:3 などと表示する
  // ただOGPは 40:21 になり 1.91:1 の方が人間向け表記としてよく使われている
  aspect_ratio_gcd(w, h) {
    w = w || 0
    h = h || 0
    if (w === 0 || h === 0) {
      return
    }
    const v = Xinteger.gcd(w, h)
    w = w / v
    h = h / v
    return [w, h]
  },
}
