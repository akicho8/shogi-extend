import { Quiz } from "@/components/ShareBoard/fes/quiz.js"
import _ from "lodash"

describe("Quiz", () => {
  describe("ClassMethods", () => {
    test("create", () => {
      const object = Quiz.create()
      expect(_.isObject(object)).toEqual(true)
    })
  })

  describe("InstanceMethods", () => {
    test("oneline_message", () => {
      expect(Quiz.sample.to_s).toEqual("どっちがお好き？？マヨネーズまたはケチャップ。")
    })

    test("valid_p", () => {
      const object = Quiz.create()
      expect(object.valid_p).toEqual(false)
    })

    test("invalid_p", () => {
      const object = Quiz.create()
      expect(object.invalid_p).toEqual(true)
    })

    test("content_hash", () => {
      const object = Quiz.create()
      expect(!!object.content_hash).toEqual(true)
    })

    describe("same_content_p", () => {
      test("メソッド名の通り内容で比較する", () => {
        const object1 = Quiz.create()
        const object2 = Quiz.create()
        expect(object1.same_content_p(object2)).toEqual(true)
      })
      // test("完全に初期値の状態では同じと見なさない", () => {
      //   const object1 = Quiz.create()
      //   const object2 = Quiz.create()
      //   expect(!!object1.same_content_p(object2)).toEqual(false)
      // })
      // test("入力があれば同じか比較する", () => {
      //   const object1 = Quiz.create({subject: "a"})
      //   const object2 = Quiz.create({subject: "a"})
      //   expect(object1.same_content_p(object2)).toEqual(true)
      // })
    })

    test("empty_p", () => {
      expect(Quiz.create().empty_p).toEqual(true)
      expect(Quiz.create({subject: "a"}).empty_p).toEqual(false)
    })

    test("attributes", () => {
      const object = Quiz.create()
      expect(_.isObject(object.attributes)).toEqual(true)
    })

    test("toJSON", () => {
      const object = Quiz.create()
      expect(_.isObject(object.toJSON())).toEqual(true)
    })

    test("dup", () => {
      const object = Quiz.create()
      expect(object.unique_code != object.dup().unique_code).toEqual(true)
    })
  })
})
