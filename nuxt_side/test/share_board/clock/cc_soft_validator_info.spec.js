import { CcSoftValidatorInfo } from "@/components/ShareBoard/clock/cc_soft_validator_info.js"

describe("CcSoftValidatorInfo", () => {
  test("works", () => {
    const params = {
      initial_main_min: 0,
      initial_read_sec: 30,
      initial_extra_min: 5,
      every_plus: 0,
    }
    expect(CcSoftValidatorInfo.match(params).key).toEqual("clock_setting_is_perfect")
  })
})
