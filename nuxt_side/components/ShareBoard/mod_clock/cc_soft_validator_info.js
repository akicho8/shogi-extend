import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import _ from "lodash"

export class CcSoftValidatorInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      {
        icon_code: "mdi-alert-circle-outline",
        icon_type: "has-text-danger",
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
        icon_code: "mdi-alert-circle-outline",
        icon_type: "has-text-danger",
        message: "上達を目的とするなら<b>秒読み</b>も設定しよう",
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
        icon_code: "mdi-alert-circle-outline",
        icon_type: "has-text-danger",
        message: "持ち時間を設定したのと同じなので<b>秒読み</b>の設定をおすすめします",
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
        icon_code: "mdi-alert-circle-outline",
        icon_type: "has-text-danger",
        message: "持ち時間と考慮時間を分ける意味がないので<b>秒読み</b>を設定しよう",
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
        icon_code: "mdi-alert-circle-outline",
        icon_type: "has-text-danger",
        message: "<b>考慮時間</b>の設定もおすすめします",
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
        icon_code: "mdi-check-bold",
        icon_type: "has-text-success",
        message: "持ち時間より<b>考慮時間</b>の設定をおすすめします",
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
        icon_code: "mdi-check-bold",
        icon_type: "has-text-success",
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
        icon_code: "mdi-alert-circle-outline",
        icon_type: "has-text-danger",
        message: "フィッシャールールでは<b>持ち時間</b>も設定しよう",
        cond_if: context => {
          return [
            context.initial_main_min === 0,
            context.every_plus >= 1,
          ]
        },
      },
      {
        icon_code: "mdi-check-bold",
        icon_type: "has-text-success",
        message: "フィッシャールールでは<b>秒読み</b>と<b>考慮時間</b>を 0 にしたほうがよいでしょう",
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
        icon_code: "mdi-check-bold",
        icon_type: "has-text-success",
        message: "最高の設定です",
        cond_if: context => true,
      },
    ]
  }

  static match(params) {
    return this.values.find(e => _.castArray(e.cond_if(params)).every(e => e))
  }

  get icon_class() {
    return [this.icon_code, this.icon_type]
  }
}
