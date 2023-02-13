import { DebugModeInfo } from "@/components/ShareBoard/models/debug_mode_info.js"

describe("DebugModeInfo", () => {
  it("works", () => {
    expect(DebugModeInfo.fetch(true).key).toEqual(true)
    expect(DebugModeInfo.fetch("true").key).toEqual(true)

    expect(DebugModeInfo.fetch(false).key).toEqual(false)
    expect(DebugModeInfo.fetch("false").key).toEqual(false)

    expect(DebugModeInfo.fetch(1).key).toEqual(true)
  })
})
