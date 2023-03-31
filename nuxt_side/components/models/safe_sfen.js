import { Gs } from "@/components/models/gs.js"

export const SafeSfen = {
  encode(sfen) {
    return Gs.urlsafe_encode64(sfen)
  },

  // Rails側と合わせていれているがまだどこでも使っていない
  decode(bin) {
    return Gs.urlsafe_decode64(bin)
  },
}
