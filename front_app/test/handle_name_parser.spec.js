import { mount } from '@vue/test-utils'
import { HandleNameParser } from '@/components/models/handle_name_parser.js'

describe('HandleNameParser', () => {
  test('呼名', () => {
    expect(HandleNameParser.call_name("foo123(456)")).toEqual("fooさん")
    expect(HandleNameParser.call_name("女王")).toEqual("女王様")
    expect(HandleNameParser.call_name("ココ")).toEqual("ココちゃん")
    expect(HandleNameParser.call_name("coco")).toEqual("cocoちゃん")
    expect(HandleNameParser.call_name("パーヤン")).toEqual("パーヤン")
    expect(HandleNameParser.call_name("ありす。")).toEqual("ありすさん")
    expect(HandleNameParser.call_name("alice@日本")).toEqual("aliceさん")
    expect(HandleNameParser.call_name("alice＠日本")).toEqual("aliceさん")
  })
})
