import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import { GX } from "@/components/models/gs.js"
import dayjs from "dayjs"

export class ValidationInfo extends ApplicationMemoryRecord {
  // TWITTERに投稿できる動画と画像の仕様について
  // https://nico-lab.net/twitter_upload_format_spec/
  static MP4_TIME_SECOND_MAX           = 140
  static MP4_SIZE_MB_MAX        = 512
  static GIF_SIZE_MB_MAX        = 5 // GIF画像はモバイル端末なら5MBまでtwitter.comなら15MBまで追加できる https://help.twitter.com/ja/using-twitter/tweeting-gifs-and-pictures
  static MP4_FPS_MAX            = 60
  static MP4_VIDEO_BIT_RATE_KBPS_MAX = 5000
  static MP4_AUDIO_BIT_RATE_KBPS_MAX = 128

  static get define() {
    return [
      {
        name: "長さ",
        should_be: c => `長さが${GX.xtime_format_human_hms(this.MP4_TIME_SECOND_MAX)}以下`,
        human_value: (c, e) => `${GX.xtime_format_human_hms(e.duration)}`,
        environment: null,
        alert_icon_key: "alert",
        alert_icon_type: "is-danger",
        validate: (c, e) => {
          if (e.recipe_info.file_type === "video") {
            let v = e.duration
            if (v != null)  {
              return v <= this.MP4_TIME_SECOND_MAX
            }
          }
        },
      },
      {
        name: "容量",
        should_be: c => `容量が ${this.MP4_SIZE_MB_MAX} MB以下`,
        human_value: (c, e) => `${GX.number_round(e.file_size / (1024 * 1024), 2)} MB`,
        environment: null,
        alert_icon_key: "alert",
        alert_icon_type: "is-danger",
        validate: (c, e) => {
          if (e.recipe_info.file_type === "video") {
            return e.file_size <= (this.MP4_SIZE_MB_MAX * 1024 * 1024)
          }
        },
      },
      {
        name: "フレームレート",
        should_be: c => `フレームレートが ${this.MP4_FPS_MAX} fps以下`,
        human_value: (c, e) => `${e.frame_rate} fps`,
        environment: null,
        alert_icon_key: "alert",
        alert_icon_type: "is-danger",
        validate: (c, e) => {
          if (e.recipe_info.file_type === "video") {
            return e.frame_rate <= this.MP4_FPS_MAX
          }
        },
      },

      // https://developer.twitter.com/ja/docs/media/upload-media/uploading-media/media-best-practices
      {
        name: "映像BR",
        should_be: c => `映像BRが ${this.MP4_VIDEO_BIT_RATE_KBPS_MAX} kbps程度(?)`,
        human_value: (c, e) => `${GX.number_round(e.video_bit_rate / 1024, 2)} kbps`,
        environment: null,
        alert_icon_key: "blank",
        alert_icon_type: "is-danger",
        validate: (c, e) => {
          if (e.recipe_info.file_type === "video") {
            return e.video_bit_rate >= this.MP4_VIDEO_BIT_RATE_KBPS_MAX * 1024 || true
          }
        },
      },

      {
        name: "音声BR",
        should_be: c => `音声BRが ${this.MP4_AUDIO_BIT_RATE_KBPS_MAX} kbps程度(?)`,
        human_value: (c, e) => `${GX.number_round(e.audio_bit_rate / 1024, 2)} kbps`,
        environment: null,
        alert_icon_key: "alert",
        alert_icon_type: "is-danger",
        validate: (c, e) => {
          if (e.recipe_info.file_type === "video") {
            if (GX.present_p(e.audio_stream)) {
              return e.audio_bit_rate >= this.MP4_AUDIO_BIT_RATE_KBPS_MAX * 1024 || true
            }
          }
        },
      },

      {
        name: "音声形式",
        should_be: c => `音声形式が AAC LC`,
        human_value: (c, e) => `${e.audio_stream.codec_name} ${e.audio_stream.profile}`,
        environment: null,
        alert_icon_key: "alert",
        alert_icon_type: "is-danger",
        validate: (c, e) => {
          if (e.recipe_info.file_type === "video") {
            if (GX.present_p(e.audio_stream)) {
              return e.audio_stream.codec_name === "aac" && e.audio_stream.profile === "LC"
            }
          }
        },
      },

      {
        name: "アスペクト比",
        should_be: c => `アスペクト比が ${c.TWITTER_ASPECT_RATIO_MAX} 以下`,
        human_value: (c, e) => GX.number_round(e.aspect_ratio_max, 2),
        environment: null,
        alert_icon_key: "alert",
        alert_icon_type: "is-danger",
        validate: (c, e) => {
          if (e.recipe_info.file_type === "video") {
            return e.aspect_ratio_max <= c.TWITTER_ASPECT_RATIO_MAX
          }
        },
      },
      {
        name: "画素形式",
        should_be: c => "画素形式が YUV420 の p",
        human_value: (c, e) => e.pix_fmt,
        environment: null,
        alert_icon_key: "alert",
        alert_icon_type: "is-danger",
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

  get icon_args() {
    return {
      icon: this.alert_icon_key,
      type: this.alert_icon_type,
    }
  }
}
