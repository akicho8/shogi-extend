import { HandleNameValidator } from "@/components/models/handle_name/handle_name_validator.js"

describe("HandleNameValidator", () => {
  test("valid_message", () => {
    expect(HandleNameValidator.valid_message("").includes("ハンドルネームを入力しよう")).toEqual(true)
  })

  test("長すぎる", () => {
    expect(HandleNameValidator.valid_message("alice６７８９０")).toEqual(null)
    expect(HandleNameValidator.valid_message("alice６７８９０１").includes("ハンドルネームは10文字以内にしよう")).toEqual(true)
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
    expect(HandleNameValidator.valid_p("foo'bar")).toEqual(false)
    expect(HandleNameValidator.valid_p('foo"bar')).toEqual(false)
    expect(HandleNameValidator.valid_p('foo@bar')).toEqual(false)
  })

  test("短かくても漢字なら良い", () => {
    expect(HandleNameValidator.valid_p("金")).toEqual(true)
  })

  test("1文字はダメ", () => {
    expect(HandleNameValidator.valid_p("き")).toEqual(false)
    expect(HandleNameValidator.valid_p("X")).toEqual(false)
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
  })

  test("バリデーションメッセージをまねる奴をNGとする", () => {
    expect(HandleNameValidator.valid_p("ハンドルネーム")).toEqual(false)
    expect(HandleNameValidator.valid_p("ニックネーム")).toEqual(false)
    expect(HandleNameValidator.valid_p("シタシミノアルナマエ")).toEqual(false)
    expect(HandleNameValidator.valid_p("素敵なハンドル")).toEqual(false)
  })

  test("全体一致捨てハン禁止", () => {
    expect(HandleNameValidator.valid_p("見学")).toEqual(false)
    expect(HandleNameValidator.valid_p("こんばんわ")).toEqual(false)
    expect(HandleNameValidator.valid_p("こんばんは")).toEqual(false)
  })

  test("全部数字はダメ", () => {
    expect(HandleNameValidator.valid_p("123")).toEqual(false)
  })

  test("全角数字のみはダメ", () => {
    expect(HandleNameValidator.valid_p("７７７")).toEqual(false)
  })

  test("中黒", () => {
    expect(HandleNameValidator.valid_p("ありす・ぼぶ")).toEqual(false)
  })

  test("NGワードはダメ", () => {
    expect(HandleNameValidator.valid_p("将棋初心者")).toEqual(false)
    expect(HandleNameValidator.valid_p("noname")).toEqual(false)
    expect(HandleNameValidator.valid_p("あああ")).toEqual(false)
    expect(HandleNameValidator.valid_p("ちんちん")).toEqual(false)
    expect(HandleNameValidator.valid_p("雑　魚")).toEqual(false)
    expect(HandleNameValidator.valid_p("雑 魚")).toEqual(false)
    expect(HandleNameValidator.valid_p("戦犯")).toEqual(false)
    expect(HandleNameValidator.valid_p("初狩り")).toEqual(false)
    expect(HandleNameValidator.valid_p("shogi-extend")).toEqual(false)
    expect(HandleNameValidator.valid_p("SHOGIEXTEND")).toEqual(false)
    expect(HandleNameValidator.valid_p("将棋ウォーズ")).toEqual(false)
  })

  test("文字を連続してNGワードを突破しようとしてもダメ", () => {
    expect(HandleNameValidator.valid_p("おおちちんんちちんん")).toEqual(false)
    expect(HandleNameValidator.valid_p("mannko")).toEqual(false)
  })

  // test("prefixが含まれるのはダメ", () => {
  //   expect(HandleNameValidator.valid_p("まじめに")).toEqual(false)
  // })

  test("長すぎるのはダメ", () => {
    expect(HandleNameValidator.valid_p("12345678901234567")).toEqual(false)
  })

  test("文章を書いているのはダメ", () => {
    expect(HandleNameValidator.valid_p("よろしく。")).toEqual(false)
    expect(HandleNameValidator.valid_p("致します")).toEqual(false)
    expect(HandleNameValidator.valid_p("ありすです")).toEqual(false)
  })

  test("絵文字のみはダメ", () => {
    expect(HandleNameValidator.valid_p("🥇")).toEqual(false)
    expect(HandleNameValidator.valid_p("🥇🥇")).toEqual(false)
  })

  test("絵文字が含んではだめ", () => {
    expect(HandleNameValidator.valid_p("ありす🥇ぼぶ")).toEqual(false)
  })

  test("GPT の成り済ましはダメ", () => {
    expect(HandleNameValidator.valid_p("GPT")).toEqual(false)
  })

  test("｢｣ (半角)", () => {
    expect(HandleNameValidator.valid_p("｢｣")).toEqual(false)
  })

  test("「」と（）と()", () => {
    expect(HandleNameValidator.valid_p("「」")).toEqual(false)
    expect(HandleNameValidator.valid_p("(foo)")).toEqual(false)
    expect(HandleNameValidator.valid_p("（ｆｏｏ）")).toEqual(false)
  })

  test("記号的な文字の繰り返し", () => {
    expect(HandleNameValidator.valid_p("_")).toEqual(false)
    expect(HandleNameValidator.valid_p("__")).toEqual(false)
  })

  test("前後に？を入れるな", () => {
    expect(HandleNameValidator.valid_p("?foo")).toEqual(false)
    expect(HandleNameValidator.valid_p("foo?")).toEqual(false)
    expect(HandleNameValidator.valid_p("？foo")).toEqual(false)
    expect(HandleNameValidator.valid_p("foo？")).toEqual(false)
  })

  test("自分に敬称をつけるな", () => {
    expect(HandleNameValidator.valid_p("fooさん")).toEqual(false)
  })

  test("スペースはいいことにする", () => {
    expect(HandleNameValidator.valid_p("foo bar")).toEqual(true)
    expect(HandleNameValidator.valid_p("foo　bar")).toEqual(true)
  })

  test("コントロール文字が含まれているものはダメ", () => {
    expect(HandleNameValidator.valid_p("foo\nbar")).toEqual(false)
    expect(HandleNameValidator.valid_p("foo\tbar")).toEqual(false)
    expect(HandleNameValidator.valid_p("foo\u007bar")).toEqual(false) // \u007 = BELL
  })

  test("ハイフンや波線は通る", () => {
    expect(HandleNameValidator.valid_p("パーマン")).toEqual(true)
    expect(HandleNameValidator.valid_p("パ〜マン")).toEqual(true)
  })

  test("ビックリマークはだめ", () => {
    expect(HandleNameValidator.valid_p("alice!")).toEqual(false)
    expect(HandleNameValidator.valid_p("alice！")).toEqual(false)
  })

  test("段級位を入れるな", () => {
    expect(HandleNameValidator.valid_p("十段のalice")).toEqual(false)
    expect(HandleNameValidator.valid_p("alice初段")).toEqual(false)
    expect(HandleNameValidator.valid_p("alice1段")).toEqual(false)
    expect(HandleNameValidator.valid_p("alice30級")).toEqual(false)
    expect(HandleNameValidator.valid_p("alice三だん")).toEqual(false)
    expect(HandleNameValidator.valid_p("alice三きゅう")).toEqual(false)
    expect(HandleNameValidator.valid_p("aliceショダン")).toEqual(false)
    expect(HandleNameValidator.valid_p("aliceさんだん")).toEqual(false)
  })

  test("ng_word_check_p が無効なら1文字も通る", () => {
    expect(HandleNameValidator.valid_p("a", {ng_word_check_p: false})).toEqual(true)
  })

  test("[bugfix] 漢字複数にひらがな一つ", () => {
    expect(HandleNameValidator.valid_p("漢字の漢字")).toEqual(true)
  })

  test("反社", () => {
    expect(HandleNameValidator.valid_p("foo893")).toEqual(false)
    expect(HandleNameValidator.valid_p("893foo")).toEqual(false)
    expect(HandleNameValidator.valid_p("foo893foo")).toEqual(false)
    expect(HandleNameValidator.valid_p("ヤクザ")).toEqual(false)
    expect(HandleNameValidator.valid_p("半グレ")).toEqual(false)
    expect(HandleNameValidator.valid_p("ヒットラー")).toEqual(false)
    expect(HandleNameValidator.valid_p("ヒトラー")).toEqual(false)
  })

  test("「々」を含む名前を許可する", () => {
    expect(HandleNameValidator.valid_p("佐々木")).toEqual(true)
  })
})
