import { Xbase64 } from "@/components/models/core/xbase64.js"

export const SafeSfen = {
  encode(sfen) {
    return Xbase64.urlsafe_encode64(sfen)
  },

  // Rails側と合わせていれているがまだどこでも使っていない
  decode(bin) {
    return Xbase64.urlsafe_decode64(bin)
  },
}
