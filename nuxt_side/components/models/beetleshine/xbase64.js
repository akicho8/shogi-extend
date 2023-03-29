// https://github.com/dankogai/js-base64
import { Base64 } from "js-base64"

export const Xbase64 = {
  urlsafe_encode64(str) {
    return Base64.encodeURI(str)
  },

  urlsafe_decode64(str) {
    return Base64.decode(str)
  },
}
