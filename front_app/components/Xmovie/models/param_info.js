import MemoryRecord from 'js-memory-record'
import { Gs } from "../../models/gs.js"

export class ParamInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "body",               type: "string",  name: "棋譜",               default: "",                                permanent: false, relation: null,                desc: "", },
      { key: "recipe_key",         type: "string",  name: "出力フォーマット",   default: "is_recipe_mp4",                   permanent: true,  relation: "RecipeInfo",        desc: "", },
      { key: "animation_size_key", type: "string",  name: "サイズ",             default: "is1280x720",                      permanent: true,  relation: "AnimationSizeInfo", desc: "", },
      { key: "i_width",            type: "string",  name: "w",                  default: null,                              permanent: true,  relation: null,                desc: "", },
      { key: "i_height",           type: "string",  name: "h",                  default: null,                              permanent: true,  relation: null,                desc: "", },
      { key: "loop_key",           type: "string",  name: "ループ",             default: "is_loop_infinite",                permanent: true,  relation: null,                desc: "", },
      { key: "viewpoint_key",      type: "string",  name: "視点",               default: "black",                           permanent: false, relation: "ViewpointInfo",     desc: "", },
      { key: "color_theme_key",    type: "string",  name: "配色",               default: "shogi_extend_theme",              permanent: true,  relation: "ColorThemeInfo",    desc: "", },
      { key: "audio_theme_key",    type: "string",  name: "BGM",                default: "audio_theme_positive_think_only", permanent: true,  relation: "AudioThemeInfo",    desc: "", },
      { key: "media_factory_key",  type: "string",  name: "生成ツール",         default: "ffmpeg",                          permanent: true,  relation: "MediaFactoryInfo",  desc: "", },
      // debug
      { key: "one_frame_duration", type: "float",   name: "1手N秒",             default: 1.0,                               permanent: true,  relation: null,                desc: "", },
      { key: "end_duration",       type: "integer", name: "最後に停止する秒数", default: 7,                                 permanent: true,  relation: null,                desc: "", },
      { key: "sleep",              type: "integer", name: "遅延",               default: 0,                                 permanent: true,  relation: null,                desc: "デバッグ用", },
      { key: "raise_message",      type: "string",  name: "例外メッセージ",     default: "",                                permanent: true,  relation: null,                desc: "デバッグ用", },
    ]
  }
}
