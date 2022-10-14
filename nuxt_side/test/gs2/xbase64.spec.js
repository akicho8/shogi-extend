import { Xbase64 } from "@/components/models/core/xbase64.js"

describe("Xbase64", () => {
  test("urlsafe_encode64", () => {
    expect(Xbase64.urlsafe_encode64("foo")).toEqual("Zm9v")
  })
  test("urlsafe_decode64", () => {
    expect(Xbase64.urlsafe_decode64("Zm9v")).toEqual("foo")
  })
})
