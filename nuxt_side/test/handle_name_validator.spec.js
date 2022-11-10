import { HandleNameValidator } from "@/components/models/handle_name/handle_name_validator.js"

describe("HandleNameValidator", () => {
  test("valid_message", () => {
    expect(HandleNameValidator.valid_message("a")).toEqual("真面目にハンドルネームを入力してください")
  })

  test("短かくても漢字なら良い", () => {
    expect(HandleNameValidator.valid_p("金")).toEqual(true)
  })

  test("文字の連続だけどありがちな名前は良い", () => {
    expect(HandleNameValidator.valid_p("キキ")).toEqual(true)
    expect(HandleNameValidator.valid_p("らら")).toEqual(true)
    expect(HandleNameValidator.valid_p("めめめ")).toEqual(true)
  })

  test("未入力はダメ", () => {
    expect(HandleNameValidator.valid_p("")).toEqual(false)
  })

  test("1文字はダメ", () => {
    expect(HandleNameValidator.valid_p("a")).toEqual(false)
    expect(HandleNameValidator.valid_p("あ")).toEqual(false)
  })

  test("明かな捨てハンは禁止", () => {
    expect(HandleNameValidator.valid_p("名無し")).toEqual(false)
    expect(HandleNameValidator.valid_p("ななし")).toEqual(false)
    expect(HandleNameValidator.valid_p("nanashi")).toEqual(false)
    expect(HandleNameValidator.valid_p("nanasi")).toEqual(false)
    expect(HandleNameValidator.valid_p("通りすがり")).toEqual(false)
    expect(HandleNameValidator.valid_p("aa")).toEqual(false)
    expect(HandleNameValidator.valid_p("aaa")).toEqual(false)
    expect(HandleNameValidator.valid_p("hoge")).toEqual(false)

    expect(HandleNameValidator.valid_p("test")).toEqual(false)
    expect(HandleNameValidator.valid_p("テスト")).toEqual(false)
    expect(HandleNameValidator.valid_p("てすと")).toEqual(false)

    expect(HandleNameValidator.valid_p("ハンドルネーム")).toEqual(false)
    expect(HandleNameValidator.valid_p("ニックネーム")).toEqual(false)
    expect(HandleNameValidator.valid_p("シタシミノアルナマエ")).toEqual(false)
  })

  test("全部数字はダメ", () => {
    expect(HandleNameValidator.valid_p("123")).toEqual(false)
    expect(HandleNameValidator.valid_p("７７７")).toEqual(false)
    expect(HandleNameValidator.valid_p("2.3")).toEqual(false)
  })

  test("NGワードはダメ", () => {
    expect(HandleNameValidator.valid_p("将棋初心者")).toEqual(false)
    expect(HandleNameValidator.valid_p("noname")).toEqual(false)
    expect(HandleNameValidator.valid_p("あああ")).toEqual(false)
    expect(HandleNameValidator.valid_p("雑　魚")).toEqual(false)
    expect(HandleNameValidator.valid_p("雑 魚")).toEqual(false)
    expect(HandleNameValidator.valid_p("戦aaa犯")).toEqual(false)
    expect(HandleNameValidator.valid_p("shogi-extend")).toEqual(false)
    expect(HandleNameValidator.valid_p("SHOGIEXTEND")).toEqual(false)
  })

  test("prefixが含まれるのはダメ", () => {
    expect(HandleNameValidator.valid_p("親しみのある")).toEqual(false)
  })

  test("長すぎるのはダメ", () => {
    expect(HandleNameValidator.valid_p("12345678901234567")).toEqual(false)
  })

  test("文章を書いているのはダメ", () => {
    expect(HandleNameValidator.valid_p("よろしく。")).toEqual(false)
  })

  test("絵文字のみはダメ", () => {
    expect(HandleNameValidator.valid_p("🥇")).toEqual(false)
    expect(HandleNameValidator.valid_p("🥇🥇")).toEqual(false)
  })
})
