import { GX } from "@/components/models/gx.js"
import { Model } from "./model.js"
import { RecipeInfo } from "./recipe_info.js"
import { StatusInfo } from "./status_info.js"
import dayjs from "dayjs"
import _ from "lodash"
import QueryString from "query-string"

export class Lemon extends Model {
  get status_info() {
    return StatusInfo.fetch(this.status_key)
  }

  //////////////////////////////////////////////////////////////////////////////// URL

  get rails_side_inline_url() {
    return this.__rails_side_url()
  }

  get rails_side_download_url() {
    return this.__rails_side_url({disposition: "attachment"})
  }

  get rails_side_json_url() {
    return this.__url_build("json")
  }

  //////////////////////////////////////////////////////////////////////////////// video 情報

  get video_stream() {
    const streams = this.ffprobe_info?.direct_format?.streams || []
    return streams[0] || {}
  }

  get pix_fmt() {
    if (this.video_stream.codec_name === "h264") {
      return this.video_stream.pix_fmt
    }
  }

  get duration() {
    let v = GX.presence(this.video_stream.duration)
    if (v) {
      return Number(v)
    }
  }

  get video_bit_rate() {
    let v = GX.presence(this.video_stream.bit_rate)
    if (v) {
      return Number(v)
    }
  }

  get width() {
    return this.video_stream.width
  }

  get height() {
    return this.video_stream.height
  }

  // get video_tag_attrs() {
  //   return {
  //     width: this.width,
  //     height: this.height,
  //   }
  // }

  // FIXME: 動画の情報ではない
  get to_wh() {
    const e = this.all_params.media_builder_params
    return { width: e.width, height: e.height }
  }

  get aspect_ratio() {
    return GX.aspect_ratio_normalize(this.width, this.height)
  }

  get aspect_ratio_max() {
    return Math.max(...this.aspect_ratio)
  }

  // "2/1" --> 1 / 2 --> 0.5 fps
  get frame_rate() {
    let [n, d] = this.video_stream.r_frame_rate.split("/")
    n = Number(n)
    d = Number(d)
    return GX.number_floor(n / d, 2)
  }

  //////////////////////////////////////////////////////////////////////////////// audio 情報

  get audio_stream() {
    const streams = this.ffprobe_info?.direct_format?.streams || []
    return streams[1] || {}
  }

  get audio_bit_rate() {
    let v = GX.presence(this.audio_stream.bit_rate)
    if (v) {
      return Number(v)
    }
  }

  // その他

  // 所要時間
  get elapsed_human() {
    if (this.process_begin_at && this.process_end_at) {
      const b = dayjs(this.process_begin_at)
      const e = dayjs(this.process_end_at)
      const s = e.diff(b, "second")
      let format = null
      if (s >= 60*60) {
        format = "h[h]m[m]"
      } else if (s >= 60) {
        format = "m[m]"
      } else {
        format = "s[s]"
      }
      return dayjs(e.diff(b)).format(format)
    }
  }

  // private

  get recipe_key() {
    return this.all_params.media_builder_params.recipe_key
  }

  get recipe_info() {
    return RecipeInfo.fetch(this.recipe_key)
  }

  get real_ext() {
    return this.recipe_info.real_ext
  }

  // Rails側のURL
  // https://localhost:3000/animation-files/1.png
  // https://localhost:3000/animation-files/1.mp4
  // https://localhost:3000/animation-files/1.json
  // https://localhost:3000/animation-files/1.mp4?disposition=inline
  // https://localhost:3000/animation-files/1.mp4?disposition=attachment
  // ・ファイル名が綺麗
  // ・本人だけがアクセス(意味ない？ → いまは外している)
  // ・拡張子をつけないと JSON を返してしまう
  // ・速度が問題なら nginx でアクセスできる browser_url にしたらいい？
  // ・→ mobile safariだとダウンロードができないので Rails 側を通すのは仕方がない
  // ・mobile safari 問題だけ解決できれば browser_url に移行できる
  // ・もしかしてnginxで特定のURLに来たときだけダウンロードにできる？
  __rails_side_url(params = {}) {
    return this.__url_build(this.real_ext, params)
  }

  __url_build(format, params = {}) {
    return QueryString.stringifyUrl({
      url: `/animation-files/${this.id}.${format}`,
      query: params,
    })
  }
}
