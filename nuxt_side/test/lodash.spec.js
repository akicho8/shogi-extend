import _ from "lodash"

describe("lodash", () => {
  test("uniqBy", () => {
    const ary = [
      { name: "a", session_id: 1, },
      { name: "a", session_id: 1, },
      { name: "b", session_id: 1, },
      { name: "b", session_id: 1, },
      { name: "a", session_id: 2, },
      { name: "a", session_id: 2, },
      { name: "b", session_id: 2, },
      { name: "b", session_id: 2, },
    ]
    const value = _.uniqBy(ary, e => [e.name, e.session_id].join("/"))
    expect(value).toEqual([
      { name: 'a', session_id: 1 },
      { name: 'b', session_id: 1 },
      { name: 'a', session_id: 2 },
      { name: 'b', session_id: 2 },
    ])
  })
})
