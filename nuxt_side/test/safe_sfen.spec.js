import { SafeSfen } from "@/components/models/safe_sfen.js"

describe("SafeSfen", () => {
  it("encode", () => {
    expect(SafeSfen.encode("position sfen 9/9/9/9/9/9/9/9/9 b - 1")).toEqual("cG9zaXRpb24gc2ZlbiA5LzkvOS85LzkvOS85LzkvOSBiIC0gMQ")
  })
  it("decode", () => {
    expect(SafeSfen.decode("cG9zaXRpb24gc2ZlbiA5LzkvOS85LzkvOS85LzkvOSBiIC0gMQ")).toEqual("position sfen 9/9/9/9/9/9/9/9/9 b - 1")
  })
})
