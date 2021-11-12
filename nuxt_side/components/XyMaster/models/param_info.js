import { ParamBase } from '@/components/models/param_base.js'

export class ParamInfo extends ParamBase {
  static get define() {
    return [
      { key: "tap_detect_key",    type: "string", name: "クリック反応",                   default: "pointerdown", permanent: true, relation: "TapDetectInfo",   desc: "", },
      { key: "board_preset_key",  type: "string", name: "ゴースト",                       default: "無",          permanent: true, relation: "BoardPresetInfo", desc: "", },
      { key: "touch_board_width", type: "float",  name: "touchデバイスでの将棋盤の幅(%)", default: 0.95,          permanent: true, relation: null,              desc: "", },
      { key: "xy_grid_stroke",    type: "float",  name: "線の太さ",                       default:  1.0,          permanent: true, relation: null,              desc: "", },
      { key: "xy_grid_color",     type: "float",  name: "線の色",                         default:  0.0,          permanent: true, relation: null,              desc: "", },
      { key: "xy_grid_star_size", type: "float",  name: "星の大きさ",                     default:   16,          permanent: true, relation: null,              desc: "", },
      { key: "xy_piece_opacity",  type: "float",  name: "ゴーストの濃さ",                 default:  0.2,          permanent: true, relation: null,              desc: "", },
    ]
  }
}
