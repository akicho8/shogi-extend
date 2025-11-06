import { HandleNameValidator } from "@/components/models/handle_name/handle_name_validator.js"

describe("HandleNameValidator", () => {
  test("valid_message", () => {
    expect(HandleNameValidator.valid_message("a").includes("ハンドルネームを入力してください")).toEqual(true)
  })

  test("長すぎる", () => {
    expect(HandleNameValidator.valid_message("alice６７８９０")).toEqual(null)
    expect(HandleNameValidator.valid_message("alice６７８９０１").includes("ハンドルネームは10文字以内にしてください")).toEqual(true)
  })

  test("危険文字", () => {
    expect(HandleNameValidator.valid_p("foo<bar")).toEqual(false)
    expect(HandleNameValidator.valid_p("foo>bar")).toEqual(false)
    expect(HandleNameValidator.valid_p("foo/bar")).toEqual(false)
    expect(HandleNameValidator.valid_p("foo+bar")).toEqual(false)
    expect(HandleNameValidator.valid_p("foo,bar")).toEqual(false)
    expect(HandleNameValidator.valid_p("foo?bar")).toEqual(false)
    expect(HandleNameValidator.valid_p("foo#bar")).toEqual(false)
    expect(HandleNameValidator.valid_p("foo=bar")).toEqual(false)
    expect(HandleNameValidator.valid_p("foo|bar")).toEqual(false)
    expect(HandleNameValidator.valid_p("foo&bar")).toEqual(false)
    expect(HandleNameValidator.valid_p("foo%bar")).toEqual(false)
    expect(HandleNameValidator.valid_p("foo~bar")).toEqual(false)
    expect(HandleNameValidator.valid_p("foo^bar")).toEqual(false)
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

  test("特定文字の繰り返しはダメ", () => {
    expect(HandleNameValidator.valid_p("a")).toEqual(false)
    expect(HandleNameValidator.valid_p("aa")).toEqual(false)
    expect(HandleNameValidator.valid_p("ああ")).toEqual(false)
    expect(HandleNameValidator.valid_p(".")).toEqual(false)
    expect(HandleNameValidator.valid_p("..")).toEqual(false)
  })

  test("特定文字からの開始はダメ", () => {
    expect(HandleNameValidator.valid_p("？foo")).toEqual(false)
    expect(HandleNameValidator.valid_p("?foo")).toEqual(false)
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
    expect(HandleNameValidator.valid_p("asdf")).toEqual(false)

    expect(HandleNameValidator.valid_p("test")).toEqual(false)
    expect(HandleNameValidator.valid_p("テスト")).toEqual(false)
    expect(HandleNameValidator.valid_p("てすと")).toEqual(false)

    expect(HandleNameValidator.valid_p("ハンドルネーム")).toEqual(false)
    expect(HandleNameValidator.valid_p("ニックネーム")).toEqual(false)
    expect(HandleNameValidator.valid_p("シタシミノアルナマエ")).toEqual(false)
  })

  test("全体一致捨てハン禁止", () => {
    expect(HandleNameValidator.valid_p("見学")).toEqual(false)
    expect(HandleNameValidator.valid_p("こんばんわ")).toEqual(false)
    expect(HandleNameValidator.valid_p("こんばんは")).toEqual(false)
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
    expect(HandleNameValidator.valid_p("ちんちん")).toEqual(false)
    expect(HandleNameValidator.valid_p("雑　魚")).toEqual(false)
    expect(HandleNameValidator.valid_p("雑 魚")).toEqual(false)
    expect(HandleNameValidator.valid_p("戦aaa犯")).toEqual(false)
    expect(HandleNameValidator.valid_p("shogi-extend")).toEqual(false)
    expect(HandleNameValidator.valid_p("SHOGIEXTEND")).toEqual(false)
  })

  test("prefixが含まれるのはダメ", () => {
    expect(HandleNameValidator.valid_p("真面目に")).toEqual(false)
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

  test("GPT の成り済ましはダメ", () => {
    expect(HandleNameValidator.valid_p("GPT")).toEqual(false)
  })

  test("段級位のみはダメ", () => {
    expect(HandleNameValidator.valid_p("初段")).toEqual(false)
    expect(HandleNameValidator.valid_p("1級")).toEqual(false)

    expect(HandleNameValidator.valid_p("初段の○")).toEqual(true)
    expect(HandleNameValidator.valid_p("○の初段")).toEqual(true)
  })

  test("「」", () => {
    expect(HandleNameValidator.valid_p("｢｣")).toEqual(false)
    expect(HandleNameValidator.valid_p("「」")).toEqual(false)
  })

  test("記号的な文字の繰り返し", () => {
    expect(HandleNameValidator.valid_p("_")).toEqual(false)
    expect(HandleNameValidator.valid_p("__")).toEqual(false)
  })
})
