import { Xthread } from "@/components/models/core/xthread.js"
import { Xobject } from "@/components/models/core/xobject.js"

describe("Xthread", () => {
  test("thread_start", async () => {
    let value = 0
    Xthread.thread_start(() => value += 1)
    await Xobject.sleep(0.1) // これがあると Download the Vue Devtools extension for a better development experience: と言われる
    expect(value).toEqual(1)
  })
})
