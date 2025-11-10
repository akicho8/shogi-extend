const Moji = require("moji")

describe("Moji", () => {
  test("works", () => {
    let moji = Moji("Ａ１[　]｢｣ｱｰﾝｶﾞﾊﾟ?？\n@＠ａ−ｂ〜ー")
    moji = moji.convert("ZS", "HS") // 全角スペース → 半角スペース
    moji = moji.convert("HK", "ZK") // 半角カナ     → 全角カナ
    moji = moji.convert("KK", "HG") // カタカナ     → ひらがな
    moji = moji.convert("ZE", "HE") // 全角英数     → 全角英数
    expect(moji.toString()).toEqual("A1[ ]「」あーんがぱ??\n@@a−b〜ー")
  })
})
