import MemoryRecord from 'js-memory-record'

export class ParamInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "body",               type: "string",  name: "棋譜",               default: "",                                desc: "", },
      { key: "recipe_key",         type: "string",  name: "出力フォーマット",   default: "is_recipe_mp4",                   desc: "", },
      { key: "animation_size_key", type: "string",  name: "サイズ",             default: "is1024x768",                      desc: "", },
      { key: "i_width",            type: "string",  name: "w",                  default: null,                              desc: "", },
      { key: "i_height",           type: "string",  name: "h",                  default: null,                              desc: "", },
      { key: "loop_key",           type: "string",  name: "ループ",             default: "is_loop_infinite",                desc: "", },
      { key: "viewpoint_key",      type: "string",  name: "視点",               default: "black",                           desc: "", },
      { key: "color_theme_key",    type: "string",  name: "色テーマ",           default: "light_mode",                      desc: "", },
      { key: "audio_theme_key",    type: "string",  name: "曲テーマ",           default: "audio_theme_positive_think_only", desc: "", },
      { key: "mp4_factory_key",    type: "string",  name: "生成ツール",         default: "ffmpeg",                           desc: "", },
      // debug
      { key: "one_frame_duration", type: "float",   name: "1手N秒",             default: 1.0,                               desc: "", },
      { key: "end_duration",       type: "integer", name: "最後に停止する秒数", default: 7,                                 desc: "", },
      { key: "sleep",              type: "integer", name: "遅延",               default: 0,                                 desc: "デバッグ用", },
      { key: "raise_message",      type: "string",  name: "例外メッセージ",     default: null,                              desc: "デバッグ用", },
    ]
  }
}
