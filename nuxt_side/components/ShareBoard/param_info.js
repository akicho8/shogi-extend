import MemoryRecord from 'js-memory-record'

export class ParamInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "share_board_column_width",      type: "float",   name: "盤の大きさ",    default: 80.0,                        permanent: true,   relation: null,        desc: "",           },
      { key: "color_theme_key",               type: "string",  name: "配色",          default: "is_color_theme_paper_simple", permanent: true,   relation: "ColorThemeInfo",        desc: "",           },

      // { key: "user_name",                     type: "string",  name: "名前",          default: "",                          permanent: true,   relation: null,        desc: "",           },
      // { key: "per",                   type: "integer", name: "1ページのアイテム数", default: 108,                         permanent: false,  relation: null,             desc: "",           },
      // { key: "page",                  type: "integer", name: "ページ",              default: 1,                           permanent: false,  relation: null,             desc: "",           },
      // { key: "body",               type: "string",  name: "棋譜",                default: "",                          permanent: false, relation: null,                desc: "",           },
      // { key: "recipe_key",         type: "string",  name: "出力フォーマット",    default: "is_recipe_mp4",             permanent: true,  relation: "RecipeInfo",        desc: "",           },
      // { key: "rect_size_key",      type: "string",  name: "サイズ",              default: "is_rect_size_1920x1080",              permanent: true,  relation: "RectSizeInfo",      desc: "",           },
      // { key: "rect_width",         type: "string",  name: "横幅",                default: null,                        permanent: true,  relation: null,                desc: "",           },
      // { key: "rect_height",        type: "string",  name: "縦幅",                default: null,                        permanent: true,  relation: null,                desc: "",           },
      // { key: "loop_key",           type: "string",  name: "ループ",              default: "is_loop_infinite",          permanent: true,  relation: null,                desc: "",           },
      // { key: "xbold_key",          type: "string",  name: "駒を太字にする条件",  default: "is_xbold_latest",           permanent: true,  relation: null,                desc: "",           },
      // { key: "viewpoint_key",      type: "string",  name: "視点",                default: "black",                     permanent: false, relation: "ViewpointInfo",     desc: "",           },
      // { key: "color_theme_key",    type: "string",  name: "配色",                default: "is_color_theme_groovy_board_texture1", permanent: true,  relation: "ColorThemeInfo",    desc: "",           },
      // { key: "audio_theme_key",    type: "string",  name: "BGM",                 default: "is_audio_theme_ds3479",     permanent: true,  relation: "AudioThemeInfo",    desc: "",           },
      // { key: "factory_method_key", type: "string",  name: "生成ツール",          default: "is_factory_method_ffmpeg",  permanent: true,  relation: "FactoryMethodInfo", desc: "",           },
      // { key: "cover_text",         type: "string",  name: "表紙文言",            default: "",                          permanent: true,  relation: null,                desc: "",           },
      // { key: "video_crf",          type: "integer", name: "映像品質レベル",      default: 23,                          permanent: true,  relation: null,                desc: "",           },
      // { key: "audio_bit_rate",     type: "string",  name: "BGMビットレート",     default: "128k",                      permanent: true,  relation: null,                desc: "",           },
      // { key: "main_volume"   ,     type: "float",   name: "BGM音量",             default: 0.3,                         permanent: true,  relation: null,                desc: "",           },
      // { key: "page_duration",      type: "float",   name: "1ページあたりの秒数", default: 1.0,                         permanent: true,  relation: null,                desc: "",           },
      // { key: "end_duration",       type: "integer", name: "最後に指定秒間停止",  default: 7,                           permanent: true,  relation: null,                desc: "",           },
      // { key: "sleep",              type: "integer", name: "遅延",                default: 0,                           permanent: true,  relation: null,                desc: "デバッグ用", },
      // { key: "raise_message",      type: "string",  name: "例外メッセージ",      default: "",                          permanent: true,  relation: null,                desc: "デバッグ用", },
    ]
  }
}
