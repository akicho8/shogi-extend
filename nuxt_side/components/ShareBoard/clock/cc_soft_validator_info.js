import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import _ from "lodash"

export class CcSoftValidatorInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      {
        icon_code: "alert-circle-outline",
        icon_type: "is-danger",
        message: "とにかく設定しよう",
        cond_if: context => {
          return [
            context.initial_main_min  === 0,
            context.initial_read_sec  === 0,
            context.initial_extra_min === 0,
            context.every_plus        === 0,
          ]
        },
      },
      {
        icon_code: "alert-circle-outline",
        icon_type: "is-danger",
        message: "棋力向上が目的であれば<b>秒読み</b>の設定をおすすめします",
        cond_if: context => {
          return [
            context.initial_main_min >= 1,
            context.initial_read_sec === 0,
            context.initial_extra_min === 0,
            context.every_plus === 0,
          ]
        },
      },
      {
        icon_code: "alert-circle-outline",
        icon_type: "is-danger",
        message: "それは持ち時間を設定したのと同じことなので、<b>秒読み</b>の設定をおすすめします",
        cond_if: context => {
          return [
            context.initial_main_min === 0,
            context.initial_read_sec === 0,
            context.initial_extra_min >= 1,
            context.every_plus === 0,
          ]
        },
      },
      {
        icon_code: "alert-circle-outline",
        icon_type: "is-danger",
        message: "それだと持ち時間と考慮時間を分ける意味がないです",
        cond_if: context => {
          return [
            context.initial_main_min >= 1,
            context.initial_read_sec === 0,
            context.initial_extra_min >= 1,
            context.every_plus === 0,
          ]
        },
      },
      {
        icon_code: "alert-circle-outline",
        icon_type: "is-danger",
        message: "<b>考慮時間</b>の設定をおすすめします",
        cond_if: context => {
          return [
            context.initial_main_min === 0,
            context.initial_read_sec >= 1,
            context.initial_extra_min === 0,
            context.every_plus === 0,
          ]
        },
      },
      {
        icon_code: "check-bold",
        icon_type: "is-success",
        message: "それでもええけど熱い終盤戦を期待するなら<b>持ち時間</b>のかわりに<b>考慮時間</b>を設定するのも良いでしょう",
        cond_if: context => {
          return [
            context.initial_main_min >= 1,
            context.initial_read_sec >= 1,
            context.initial_extra_min === 0,
            context.every_plus === 0,
          ]
        },
      },
      {
        icon_code: "check-bold",
        icon_type: "is-success",
        message: "NHK杯のような設定です",
        cond_if: context => {
          return [
            context.initial_main_min >= 1,
            context.initial_read_sec >= 1,
            context.initial_extra_min >= 1,
            context.every_plus === 0,
          ]
        },
      },

      //////////////////////////////////////////////////////////////////////////////// フィッシャールール

      {
        icon_code: "alert-circle-outline",
        icon_type: "is-danger",
        message: "フィッシャールールでは<b>持ち時間</b>も設定しよう",
        cond_if: context => {
          return [
            context.initial_main_min === 0,
            context.every_plus >= 1,
          ]
        },
      },
      {
        icon_code: "check-bold",
        icon_type: "is-success",
        message: "それでもええけど、フィッシャーなら混乱を避けるため、<b>秒読み</b>と<b>考慮時間</b>を 0 にしておいたほうがいいかもしれない",
        cond_if: context => {
          return [
            context.initial_main_min >= 1,
            context.initial_read_sec >= 1 || context.initial_extra_min >= 1,
            context.every_plus >= 1,
          ]
        },
      },

      //////////////////////////////////////////////////////////////////////////////// 理想的

      {
        key: "clock_setting_is_perfect",
        icon_code: "check-bold",
        icon_type: "is-success",
        message: "たいへん良い設定です",
        cond_if: context => true,
      },
    ]
  }

  static match(params) {
    return this.values.find(e => _.castArray(e.cond_if(params)).every(e => e))
  }
}
