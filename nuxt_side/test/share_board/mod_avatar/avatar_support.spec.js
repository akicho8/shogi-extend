import { AvatarSupport } from "@/components/ShareBoard/mod_avatar/avatar_support.js"

describe("AvatarSupport", () => {
  test("strict_chars_count", () => {
    expect(AvatarSupport.strict_chars_count("❤️❤️")).toEqual(2)
  })
  test("strict_chars", () => {
    expect(AvatarSupport.strict_chars("❤️❤️")).toEqual(["❤️", "❤️"])
  })
  test("record_find", () => {
    const record = AvatarSupport.record_find("❤️❤️")
    expect(record.url).toEqual("https://cdn.jsdelivr.net/gh/jdecked/twemoji@latest/assets/svg/2764.svg")

    expect(AvatarSupport.record_find("")).toEqual(undefined)
  })
})
