import MemoryRecord from 'js-memory-record'
import { Gs } from "../../../components/models/gs.js"
import dayjs from "dayjs"

export class ValidationInfo extends MemoryRecord {
  static MP4_TIME_MAX = 140
  static MP4_SIZE_MB_MAX = 512
  static GIF_SIZE_MB_MAX = 5 // GIF画像はモバイル端末なら5MBまでtwitter.comなら15MBまで追加できる https://help.twitter.com/ja/using-twitter/tweeting-gifs-and-pictures
  static MP4_FPS_MAX = 60

  static get define() {
    return [
      {
        name: "時間",
        should_be: c => `時間が${Gs.time_format_human_hms(this.MP4_TIME_MAX)}以下`,
        human_value: (c, e) => `${Gs.time_format_human_hms(e.duration)}`,
        validate: (c, e) => {
          if (e.recipe_info.file_type === "video") {
            let v = e.duration
            if (v != null)  {
              return v <= this.MP4_TIME_MAX
            }
          }
        },
      },
      {
        name: "容量",
        should_be: c => `容量が${this.MP4_SIZE_MB_MAX}MB以下`,
        human_value: (c, e) => `${Gs.number_round(e.file_size / (1024 * 1024), 2)}MB`,
        validate: (c, e) => {
          if (e.recipe_info.file_type === "video") {
            return e.file_size <= (this.MP4_SIZE_MB_MAX * 1024 * 1024)
          }
        },
      },
      {
        name: "フレームレート",
        should_be: c => `フレームレートが${this.MP4_FPS_MAX}fps以下`,
        human_value: (c, e) => `${e.frame_rate}fps`,
        validate: (c, e) => {
          if (e.recipe_info.file_type === "video") {
            return e.frame_rate <= this.MP4_FPS_MAX
          }
        },
      },
      {
        name: "Audio形式",
        should_be: c => `Audio形式が AAC LC`,
        human_value: (c, e) => `${e.audio_stream.codec_name} ${e.audio_stream.profile}`,
        validate: (c, e) => {
          if (e.recipe_info.file_type === "video") {
            if (Gs.present_p(e.audio_stream)) {
              return e.audio_stream.codec_name === "aac" && e.audio_stream.profile === "LC"
            }
          }
        },
      },
      {
        name: "アスペクト比",
        should_be: c => `アスペクト比が${c.TWITTER_ASPECT_RATIO_MAX}以下`,
        human_value: (c, e) => Gs.number_round(e.aspect_ratio_max, 2),
        validate: (c, e) => {
          if (e.recipe_info.file_type === "video") {
            return e.aspect_ratio_max <= c.TWITTER_ASPECT_RATIO_MAX
          }
        },
      },
      {
        name: "画素形式",
        should_be: c => "画素形式が YUV420",
        human_value: (c, e) => e.pix_fmt,
        validate: (c, e) => {
          if (e.recipe_info.file_type === "video") {
            if (e.pix_fmt) {
              return e.pix_fmt === "yuv420p"
            }
          }
        },
      },
    ]
  }
}
