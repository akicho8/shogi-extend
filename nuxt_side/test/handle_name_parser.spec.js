import { HandleNameParser } from "@/components/models/handle_name/handle_name_parser.js"

describe("HandleNameParser", () => {
  test("基本", () => {
    expect(HandleNameParser.call_name("foo123(456)")).toEqual("fooさん")
    expect(HandleNameParser.call_name("fooさん")).toEqual("fooさん")
    expect(HandleNameParser.call_name("fooだよ")).toEqual("fooさん")
    expect(HandleNameParser.call_name("女王")).toEqual("女王様")
    expect(HandleNameParser.call_name("ココ")).toEqual("ココちゃん")
    expect(HandleNameParser.call_name("coco")).toEqual("cocoちゃん")
    expect(HandleNameParser.call_name("パーヤン")).toEqual("パーヤン")
    expect(HandleNameParser.call_name("あ。り。す。")).toEqual("ありすさん")
    expect(HandleNameParser.call_name("あ☆り☆す☆")).toEqual("ありすさん")
    expect(HandleNameParser.call_name("あ★り★す★")).toEqual("ありすさん")
    expect(HandleNameParser.call_name("alice@日本")).toEqual("aliceさん")
    expect(HandleNameParser.call_name("alice＠日本")).toEqual("aliceさん")
    expect(HandleNameParser.call_name("中の人")).toEqual("中の人")
  })

  test("語尾のゴミを取る", () => {
    expect(HandleNameParser.call_name("alice!")).toEqual("aliceさん")
    expect(HandleNameParser.call_name("alice！")).toEqual("aliceさん")
    expect(HandleNameParser.call_name("alice!!")).toEqual("aliceさん")
    expect(HandleNameParser.call_name("alice.")).toEqual("aliceさん")
    expect(HandleNameParser.call_name("alice-")).toEqual("aliceさん")
  })

  test("ん", () => {
    expect(HandleNameParser.call_name("○ん")).toEqual("○んさん")
    expect(HandleNameParser.call_name("○○ん")).toEqual("○○んさん")
    expect(HandleNameParser.call_name("○○○ん")).toEqual("○○○ん")
    expect(HandleNameParser.call_name("○○○○ん")).toEqual("○○○○ん")
  })

  test("ー", () => {
    expect(HandleNameParser.call_name("○ー")).toEqual("○ーさん")
    expect(HandleNameParser.call_name("○○ー")).toEqual("○○ーさん")
    expect(HandleNameParser.call_name("○○○ー")).toEqual("○○○ー")
    expect(HandleNameParser.call_name("○○○○ー")).toEqual("○○○○ー")
  })

  test("ちゃん", () => {
    expect(HandleNameParser.call_name("aliceちゃん")).toEqual("aliceちゃん") // 最後が "ん" の影響でスルーされているだけ
  })

  test("くん", () => {
    expect(HandleNameParser.call_name("aliceくん")).toEqual("aliceくん")
    expect(HandleNameParser.call_name("alice君")).toEqual("alice君")
  })

  test("もともとニックネームのような人に敬称をつけない", () => {
    expect(HandleNameParser.call_name("alicechan")).toEqual("alicechan")
    expect(HandleNameParser.call_name("alicekun")).toEqual("alicekun")
    expect(HandleNameParser.call_name("ALICECHAN")).toEqual("ALICECHAN")
    expect(HandleNameParser.call_name("○○民")).toEqual("○○民")
  })

  test("絵文字が語尾に含まれる場合は除去する", () => {
    expect(HandleNameParser.call_name("alice🍓")).toEqual("aliceさん")
  })

  test("なんとかして装飾を削除する", () => {
    expect(HandleNameParser.call_name("○○○ンです( ᐛ )／")).toEqual("○○○ン")
  })

  test("Xさん777", () => {
    expect(HandleNameParser.call_name("Xさん777")).toEqual("Xさん")
  })
})
