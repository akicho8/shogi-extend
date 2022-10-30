import { Xthread } from "@/components/models/core/xthread.js"
import { Xobject } from "@/components/models/core/xobject.js"

describe("Xthread", () => {
  test("thread_start", async () => {
    let value = 0
    Xthread.thread_start(() => value += 1)
    await Xobject.sleep(0.1)
    expect(value).toEqual(1)
  })
})
