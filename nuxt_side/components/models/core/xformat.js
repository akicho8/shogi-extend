import Extsprintf from "extsprintf"

export const Xformat = {
  format(...args) {
    return Extsprintf.sprintf(...args)
  },
}
