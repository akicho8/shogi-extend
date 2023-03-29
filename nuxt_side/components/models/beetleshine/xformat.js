import Extsprintf from "extsprintf"

export const Xformat = {
  // format にすると何かと衝突する
  sprintf(...args) {
    return Extsprintf.sprintf(...args)
  },
}
