import { RoleGroup } from "@/components/ShareBoard/mod_role/role_group.js"
import { Location } from "shogi-player/components/models/location.js"

describe("RoleGroup", () => {
  test("#team_name", () => {
    expect(RoleGroup.create({black: []}).team_name(Location.black)).toEqual("☗")
    expect(RoleGroup.create({black: ["a"]}).team_name(Location.black)).toEqual("aさん")
    expect(RoleGroup.create({black: ["a", "b"]}).team_name(Location.black)).toEqual("aチーム")
  })
})
