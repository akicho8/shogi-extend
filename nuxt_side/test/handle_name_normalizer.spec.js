import { HandleNameNormalizer } from "@/components/models/handle_name/handle_name_normalizer.js"

describe("HandleNameNormalizer", () => {
  test("normalize", () => {
    expect(HandleNameNormalizer.normalize("　 　alice　 　1級　 　")).toEqual("alice 1級")
  })
  test("文字の変換はしない", () => {
    expect(HandleNameNormalizer.normalize("Ａア０！")).toEqual("Ａア０！")
  })
})
