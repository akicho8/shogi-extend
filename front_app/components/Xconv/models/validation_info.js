import MemoryRecord from 'js-memory-record'
import { Gs } from "../../../components/models/gs.js"
import dayjs from "dayjs"

export class ReviewValidationInfo extends MemoryRecord {
  static MOVIE_TIME_MAX = 140
  static MOVIE_SIZE_KB_MAX = 512
  
  static get define() {
    return [
      {
        name: "時間",
        should_be: c => `時間が${Gs.time_format_human_hms(this.MOVIE_TIME_MAX)}以下`,
        human_value: (c, e) => `${Gs.time_format_human_hms(e.duration)}`,
        validate: (c, e) => {
          let v = e.duration
          if (v != null)  {
            return v <= this.MOVIE_TIME_MAX
          }
        },
      },
      {
        name: "容量",
        should_be: c => `容量が${this.MOVIE_SIZE_KB_MAX}MB以下`,
        human_value: (c, e) => `${Gs.number_round(e.file_size / (1024 * 1024), 2)}MB`,
        validate: (c, e) => e.file_size <= (this.MOVIE_SIZE_KB_MAX * 1024 * 1024),
      },
      {
        name: "アスペクト比",
        should_be: c => `アスペクト比が${c.TWITTER_ASPECT_RATIO_MAX}以下`,
        human_value: (c, e) => Gs.number_round(e.aspect_ratio_max, 2),
        validate: (c, e) => e.aspect_ratio_max <= c.TWITTER_ASPECT_RATIO_MAX,
      },
      {
        name: "色形式",
        should_be: c => "色形式が YUV420",
        human_value: (c, e) => e.pix_fmt,
        validate: (c, e) => {
          if (e.pix_fmt) {
            return e.pix_fmt === "yuv420p"
          }
        },
      },
    ]
  }
}
