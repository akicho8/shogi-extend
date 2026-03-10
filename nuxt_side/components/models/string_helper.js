import { GX } from "@/components/models/gx.js"
const Moji = require("moji")

export class StringHelper {
  static hankaku_kana_format(str) {
    return Moji(str).convert("ZK", "HK").toString()
  }
}
