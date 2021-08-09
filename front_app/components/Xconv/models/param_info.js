import MemoryRecord from 'js-memory-record'

export class ParamInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "body",               type: "string",  name: "棋譜",                       default: "",                 desc: "", },
      { key: "loop_key",           type: "string",  name: "ループ",                     default: "is_loop_infinite", desc: "", },
      { key: "animation_size_key", type: "string",  name: "サイズ",                     default: "is1024x768",       desc: "", },
      { key: "i_width",            type: "string",  name: "w",                          default: null,               desc: "", },
      { key: "i_height",           type: "string",  name: "h",                          default: null,               desc: "", },
      { key: "viewpoint_key",      type: "string",  name: "視点",                       default: "black",            desc: "", },
      { key: "delay_per_one",      type: "float",   name: "表示秒数/1枚",               default: 1.0,                desc: "", },
      { key: "end_frames",         type: "integer", name: "終了図だけ指定枚数ぶん停止", default: 3,                  desc: "デバッグ用", },
      { key: "sleep",              type: "integer", name: "遅延",                       default: 0,                  desc: "デバッグ用", },
      { key: "raise_message",      type: "string",  name: "例外メッセージ",             default: null,               desc: "", },
      { key: "xout_format_key",    type: "string",  name: "出力形式",                   default: "is_format_mp4",    desc: "", },
    ]
  }
}
