const qs = require("qs")
const URI = require("urijs")
const strictUriEncode = require("strict-uri-encode")
const queryString = require("query-string")

describe("各種エンコードの違い", () => {
  const str = " !\"\#$%&'()*+,-./:;<=>?@[\\]^_`{|}~"
  it("encodeURIComponent", () => {
    expect(encodeURIComponent(str)).toEqual("%20!%22%23%24%25%26'()*%2B%2C-.%2F%3A%3B%3C%3D%3E%3F%40%5B%5C%5D%5E_%60%7B%7C%7D~")
  })
  it("strict-uri-encode", () => {
    expect(strictUriEncode(str)).toEqual("%20%21%22%23%24%25%26%27%28%29%2A%2B%2C-.%2F%3A%3B%3C%3D%3E%3F%40%5B%5C%5D%5E_%60%7B%7C%7D~")
  })
  it("qs", () => {
    expect(qs.stringify({x: str})).toEqual("x=%20%21%22%23%24%25%26%27%28%29%2A%2B%2C-.%2F%3A%3B%3C%3D%3E%3F%40%5B%5C%5D%5E_%60%7B%7C%7D~")
    expect(qs.stringify({x: str}, {format: "RFC3986"})).toEqual("x=%20%21%22%23%24%25%26%27%28%29%2A%2B%2C-.%2F%3A%3B%3C%3D%3E%3F%40%5B%5C%5D%5E_%60%7B%7C%7D~")
    expect(qs.stringify({x: str}, {format: "RFC1738"})).toEqual("x=+%21%22%23%24%25%26%27()%2A%2B%2C-.%2F%3A%3B%3C%3D%3E%3F%40%5B%5C%5D%5E_%60%7B%7C%7D~")
  })
  it("query-string", () => {
    expect(queryString.stringifyUrl({url: "https://httpbin.org/get", query: {x: str}, fragmentIdentifier: 2})).toEqual("https://httpbin.org/get?x=%20%21%22%23%24%25%26%27%28%29%2A%2B%2C-.%2F%3A%3B%3C%3D%3E%3F%40%5B%5C%5D%5E_%60%7B%7C%7D~#2")
  })
  it("URI.js", () => {
    expect(URI("https://httpbin.org/get").query({x: str}).toString()).toEqual("https://httpbin.org/get?x=+%21%22%23%24%25%26%27%28%29%2A%2B%2C-.%2F%3A%3B%3C%3D%3E%3F%40%5B%5C%5D%5E_%60%7B%7C%7D~")
  })
})
