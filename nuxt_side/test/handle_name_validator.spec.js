import { HandleNameValidator } from "@/components/models/handle_name_validator.js"

describe("HandleNameValidator", () => {
  test("短かくても漢字なら良い", () => {
    expect(HandleNameValidator.valid("金")).toEqual(true)
  })

  test("文字の連続だけどありがちな名前は良い", () => {
    expect(HandleNameValidator.valid("キキ")).toEqual(true)
    expect(HandleNameValidator.valid("らら")).toEqual(true)
    expect(HandleNameValidator.valid("めめめ")).toEqual(true)
  })

  test("未入力はダメ", () => {
    expect(HandleNameValidator.valid("")).toEqual(false)
  })

  test("1文字はダメ", () => {
    expect(HandleNameValidator.valid("a")).toEqual(false)
    expect(HandleNameValidator.valid("あ")).toEqual(false)
  })

  test("明かな捨てハンは禁止", () => {
    expect(HandleNameValidator.valid("名無し")).toEqual(false)
    expect(HandleNameValidator.valid("ななし")).toEqual(false)
    expect(HandleNameValidator.valid("nanashi")).toEqual(false)
    expect(HandleNameValidator.valid("nanasi")).toEqual(false)
    expect(HandleNameValidator.valid("通りすがり")).toEqual(false)
    expect(HandleNameValidator.valid("aa")).toEqual(false)
    expect(HandleNameValidator.valid("aaa")).toEqual(false)
    expect(HandleNameValidator.valid("hoge")).toEqual(false)

    expect(HandleNameValidator.valid("test")).toEqual(false)
    expect(HandleNameValidator.valid("テスト")).toEqual(false)
    expect(HandleNameValidator.valid("てすと")).toEqual(false)

    expect(HandleNameValidator.valid("ハンドルネーム")).toEqual(false)
    expect(HandleNameValidator.valid("ニックネーム")).toEqual(false)
    expect(HandleNameValidator.valid("シタシミノアルナマエ")).toEqual(false)
  })

  test("全部数字はダメ", () => {
    expect(HandleNameValidator.valid("123")).toEqual(false)
    expect(HandleNameValidator.valid("７７７")).toEqual(false)
    expect(HandleNameValidator.valid("2.3")).toEqual(false)
  })

  test("NGワードはダメ", () => {
    expect(HandleNameValidator.valid("将棋初心者")).toEqual(false)
    expect(HandleNameValidator.valid("noname")).toEqual(false)
    expect(HandleNameValidator.valid("あああ")).toEqual(false)
    expect(HandleNameValidator.valid("雑　魚")).toEqual(false)
    expect(HandleNameValidator.valid("雑 魚")).toEqual(false)
    expect(HandleNameValidator.valid("戦aaa犯")).toEqual(false)
    expect(HandleNameValidator.valid("shogi-extend")).toEqual(false)
    expect(HandleNameValidator.valid("SHOGIEXTEND")).toEqual(false)
  })

  test("prefixが含まれるのはダメ", () => {
    expect(HandleNameValidator.valid("親しみのある")).toEqual(false)
  })

  test("長すぎるのはダメ", () => {
    expect(HandleNameValidator.valid("12345678901234567")).toEqual(false)
  })

  test("文章を書いているのはダメ", () => {
    expect(HandleNameValidator.valid("よろしく。")).toEqual(false)
  })

  test("絵文字のみはダメ", () => {
    expect(HandleNameValidator.valid("🥇")).toEqual(false)
    expect(HandleNameValidator.valid("🥇🥇")).toEqual(false)
  })
})
