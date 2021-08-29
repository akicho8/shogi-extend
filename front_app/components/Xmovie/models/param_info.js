import MemoryRecord from 'js-memory-record'
import { Gs } from "../../models/gs.js"

export class ParamInfo extends MemoryRecord {
  // static build_by(query) {
  //   const data = {}
  //   this.values.forEach(e => {
  //     let v = query[e.key]
  //     if (Gs.present_p(v)) {
  //       if (e.type === "integer") {
  //         v = Math.trunc(Number(v))
  //       } else if (e.type === "float") {
  //         v = Number(v)
  //       }
  //       data[e.key] = v
  //     } else {
  //       data[e.key] = e.default
  //     }
  //   })
  //   return data
  // }
  // 
  // static build_by2(key, query) {
  //   const e = this.fetch(key)
  //   let v = query[e.key]
  //   if (Gs.present_p(v)) {
  //     if (e.type === "integer") {
  //       v = Math.trunc(Number(v))
  //     } else if (e.type === "float") {
  //       v = Number(v)
  //     }
  //     return v
  //   } else {
  //     return e.default
  //   }
  // }

  static get define() {
    return [
      { key: "body",               type: "string",  name: "棋譜",               default: "",                                permanent: false, desc: "", },
      { key: "recipe_key",         type: "string",  name: "出力フォーマット",   default: "is_recipe_mp4",                   permanent: true,  desc: "", },
      { key: "animation_size_key", type: "string",  name: "サイズ",             default: "is1024x768",                      permanent: true,  desc: "", },
      { key: "i_width",            type: "string",  name: "w",                  default: null,                              permanent: true,  desc: "", },
      { key: "i_height",           type: "string",  name: "h",                  default: null,                              permanent: true,  desc: "", },
      { key: "loop_key",           type: "string",  name: "ループ",             default: "is_loop_infinite",                permanent: true,  desc: "", },
      { key: "viewpoint_key",      type: "string",  name: "視点",               default: "black",                           permanent: false, desc: "", },
      { key: "color_theme_key",    type: "string",  name: "配色",               default: "first_light_theme",                      permanent: true,  desc: "", },
      { key: "audio_theme_key",    type: "string",  name: "BGM",                default: "audio_theme_positive_think_only", permanent: true,  desc: "", },
      { key: "media_factory_key",  type: "string",  name: "生成ツール",         default: "ffmpeg",                          permanent: true,  desc: "", },
      // debug
      { key: "one_frame_duration", type: "float",   name: "1手N秒",             default: 1.0,                               permanent: true,  desc: "", },
      { key: "end_duration",       type: "integer", name: "最後に停止する秒数", default: 7,                                 permanent: true,  desc: "", },
      { key: "sleep",              type: "integer", name: "遅延",               default: 0,                                 permanent: false, desc: "デバッグ用", },
      { key: "raise_message",      type: "string",  name: "例外メッセージ",     default: null,                              permanent: false, desc: "デバッグ用", },
    ]
  }

  // build_by3(query) {
  //   let v = query[this.key]
  //   if (Gs.present_p(v)) {
  //     if (this.type === "integer") {
  //       v = Math.trunc(Number(v))
  //     } else if (this.type === "float") {
  //       v = Number(v)
  //     }
  //     return v
  //   } else {
  //     return this.default
  //   }
  // }
}
