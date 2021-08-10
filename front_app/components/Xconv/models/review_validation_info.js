import MemoryRecord from 'js-memory-record'

export class ReviewValidationInfo extends MemoryRecord {
  static get define() {
    return [
      {
        name: "色情報形式",
        validate: context => {
          const v = context.done_record_stream.pix_fmt
          if (v) {
            if (context.done_record_stream.codec_name === "h264") {
              if (v !== "yuv420p") {
                return `色情報形式が yuv420p ではない : ${v}`
              }
            }
          }
        },
      },
      {
        name: "長さ",
        validate: context => {
          const max = 140
          let v = context.done_record_stream.duration
          if (v) {
            v = Number(v)
            if (v > max) {
              return `長さが${max}秒を超えている : ${v}秒`
            }
          }
        },
      },
      {
        name: "ファイルサイズ",
        validate: context => {
          const max_kb = 512
          const one_kb = 1024 * 1024
          const v = context.done_record.file_size
          if (v >= max_kb * one_kb) {
            return `ファイルサイズが512MBを超えている : ${v / one_kb}MB`
          }
        },
      },
      {
        name: "アスペクト比",
        validate: context => {
          const v = context.math_wh_normalize_aspect_ratio(context.i_width, context.i_height)
          if (v) {
            const max = Math.max(...v)
            if (max > context.TWITTER_ASPECT_RATIO_MAX) {
              return `縦横比が大きすぎる : ${v.join(":")}`
            }
          }
        },
      },
    ]
  }
}
