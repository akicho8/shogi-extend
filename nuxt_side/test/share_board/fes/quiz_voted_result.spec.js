import { QuizVotedResult } from "@/components/ShareBoard/fes/quiz_voted_result.js"
import _ from "lodash"

describe("QuizVotedResult", () => {
  describe("ClassMethods", () => {
    test("create", () => {
      const object = QuizVotedResult.create()
      expect(object.to_h).toEqual({})
    })
  })

  describe("InstanceMethods", () => {
    test("count", () => {
      const object = QuizVotedResult.create({alice: 0})
      expect(object.count).toEqual(1)
    })

    test("user_names", () => {
      const object = QuizVotedResult.create({alice: 0})
      expect(object.user_names).toEqual(["alice"])
    })

    test("post", () => {
      const object = QuizVotedResult.create()
      expect(object.post("alice", 1).to_h).toEqual({alice: 1})
    })

    test("merge", () => {
      const object = QuizVotedResult.create({alice: 0})
      expect(object.merge({bob: 1}).to_h).toEqual({alice: 0, bob: 1})
    })

    test("already_vote_p", () => {
      const object = QuizVotedResult.create({alice: 0})
      expect(object.already_vote_p("alice")).toEqual(true)
    })

    test("toJSON", () => {
      const object = QuizVotedResult.create()
      expect(object.toJSON()).toEqual({})
    })

    test("to_h", () => {
      const object = QuizVotedResult.create()
      expect(object.toJSON()).toEqual({})
    })
  })
})
