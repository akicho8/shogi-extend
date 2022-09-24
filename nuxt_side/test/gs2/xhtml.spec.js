import { Xhtml } from "@/components/models/core/xhtml.js"

describe("Xhtml", () => {
  test("auto_link", () => {
    expect(Xhtml.auto_link("@foo")).toEqual("<a href=\"https://twitter.com/foo\" target=\"_blank\" rel=\"noopener noreferrer\">@foo</a>")
  })
  test("simple_format", () => {
    expect(Xhtml.simple_format("a\nb")).toEqual("a<br/>b")
  })
  test("strip_tags", () => {
    expect(Xhtml.strip_tags("<a>foo</a>")).toEqual("foo")
  })
})
