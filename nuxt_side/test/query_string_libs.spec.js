const StrictUriEncode = require("strict-uri-encode")
const QueryString = require("query-string")

describe("URL関連", () => {
  describe("各種エンコードの違い", () => {
    const str = " !\"\#$%&'()*+,-./:;<=>?@[\\]^_`{|}~"

    test("encodeURIComponent", () => {
      expect(encodeURIComponent(str)).toEqual("%20!%22%23%24%25%26'()*%2B%2C-.%2F%3A%3B%3C%3D%3E%3F%40%5B%5C%5D%5E_%60%7B%7C%7D~")
    })

    test("strict-uri-encode", () => {
      expect(StrictUriEncode(str)).toEqual("%20%21%22%23%24%25%26%27%28%29%2A%2B%2C-.%2F%3A%3B%3C%3D%3E%3F%40%5B%5C%5D%5E_%60%7B%7C%7D~")
    })

    test("query-string", () => {
      expect(QueryString.stringifyUrl({url: "https://httpbin.org/get", query: {x: str}, fragmentIdentifier: 2})).toEqual("https://httpbin.org/get?x=%20%21%22%23%24%25%26%27%28%29%2A%2B%2C-.%2F%3A%3B%3C%3D%3E%3F%40%5B%5C%5D%5E_%60%7B%7C%7D~#2")
    })
  })

  describe("読み込み", () => {
    test("query-string", () => {
      expect(QueryString.parse("?a=1").a).toEqual("1")
      expect(QueryString.parse("")).toEqual({})
    })
  })
})
