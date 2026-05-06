import { MisuseDetector } from "@/components/ShareBoard/mod_move_sync/misuse_detector.js"

describe("MisuseDetector", () => {
  test("works", () => {
    let executed = 0
    const misuse_detector = MisuseDetector.create({count_max: 2, callback: () => { executed += 1 }})
    misuse_detector.call({location_key: "black", turn: 1})
    misuse_detector.call({location_key: "black", turn: 1})
    expect(executed).toEqual(1)

    // misuse_detector.call({location_key: "black", turn: 1})
    // misuse_detector.call({location_key: "black", turn: 1})
    // expect(executed).toEqual(2)
  })
})
