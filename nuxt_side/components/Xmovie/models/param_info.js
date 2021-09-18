import MemoryRecord from 'js-memory-record'
import { Gs } from "../../models/gs.js"

export class ParamInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "body",               type: "string",  name: "棋譜",               default: "",                          permanent: false, relation: null,                desc: "",           },
      { key: "recipe_key",         type: "string",  name: "出力フォーマット",   default: "is_recipe_mp4",             permanent: true,  relation: "RecipeInfo",        desc: "",           },
      { key: "animation_size_key", type: "string",  name: "サイズ",             default: "is1280x720",                permanent: true,  relation: "AnimationSizeInfo", desc: "",           },
      { key: "img_width",          type: "string",  name: "w",                  default: null,                        permanent: true,  relation: null,                desc: "",           },
      { key: "img_height",         type: "string",  name: "h",                  default: null,                        permanent: true,  relation: null,                desc: "",           },
      { key: "loop_key",           type: "string",  name: "ループ",             default: "is_loop_infinite",          permanent: true,  relation: null,                desc: "",           },
      { key: "xfont_key",          type: "string",  name: "ループ",             default: "is_font_auto",              permanent: true,  relation: null,                desc: "",           },
      { key: "viewpoint_key",      type: "string",  name: "視点",               default: "black",                     permanent: false, relation: "ViewpointInfo",     desc: "",           },
      { key: "color_theme_key",    type: "string",  name: "配色",               default: "color_theme_is_real_wood1", permanent: true,  relation: "ColorThemeInfo",    desc: "",           },
      { key: "audio_theme_key",    type: "string",  name: "BGM",                default: "audio_theme_is_ds3479",     permanent: true,  relation: "AudioThemeInfo",    desc: "",           },
      { key: "media_factory_key",  type: "string",  name: "生成ツール",         default: "ffmpeg",                    permanent: true,  relation: "MediaFactoryInfo",  desc: "",           },
      { key: "cover_text",         type: "string",  name: "表紙文言",           default: "",                          permanent: true,  relation: null,                desc: "",           },
      { key: "video_crf",          type: "integer", name: "映像品質レベル",     default: 23,                          permanent: true,  relation: null,                desc: "",           },
      { key: "audio_bit_rate",     type: "string",  name: "音声ビットレート",   default: "128k",                      permanent: true,  relation: null,                desc: "",           },
      { key: "page_duration",      type: "float",   name: "1手N秒",             default: 1.0,                         permanent: true,  relation: null,                desc: "",           },
      { key: "end_duration",       type: "integer", name: "最後に指定秒間停止", default: 7,                           permanent: true,  relation: null,                desc: "",           },
      { key: "sleep",              type: "integer", name: "遅延",               default: 0,                           permanent: true,  relation: null,                desc: "デバッグ用", },
      { key: "raise_message",      type: "string",  name: "例外メッセージ",     default: "",                          permanent: true,  relation: null,                desc: "デバッグ用", },
    ]
  }
}
