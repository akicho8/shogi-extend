import { Model } from "./model.js"
import { XoutFormatInfo } from "./xout_format_info.js"
import { StatusInfo } from "./status_info.js"
import _ from "lodash"

export class XconvRecord extends Model {
  get rails_side_inline_url() {
    return this.__rails_side_url()
  }

  get rails_side_download_url() {
    return this.__rails_side_url({disposition: "attachment"})
  }

  get rails_side_json_url() {
    return this.__url_build("json")
  }

  get to_wh() {
    const e = this.convert_params.board_file_generator_params
    return { width: e.width, height: e.height }
  }

  get status_info() {
    return StatusInfo.fetch(this.status_key)
  }

  // private

  get xout_format_key() {
    return this.convert_params.board_file_generator_params.xout_format_key
  }

  get xout_format_info() {
    return XoutFormatInfo.fetch(this.xout_format_key)
  }

  get real_ext() {
    return this.xout_format_info.real_ext
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
    const url_base = this.context.$config.MY_SITE_URL + `/animation-files/${this.id}.${format}`
    const url = new URL(url_base)
    _.each(params, (v, k) => url.searchParams.set(k, v))
    return url.toString()
  }
}
