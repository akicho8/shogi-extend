import { GX } from "@/components/models/gs.js"

export const SafeSfen = {
  encode(sfen) {
    return GX.urlsafe_encode64(sfen)
  },

  // Rails側と合わせていれているがまだどこでも使っていない
  decode(bin) {
    return GX.urlsafe_decode64(bin)
  },
}
