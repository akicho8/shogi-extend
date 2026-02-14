import { PaletteInfo } from "@/components/models/palette_info.js"
import chroma from 'chroma-js'

export const PaletteGenerator = {
  // diff ずつ count 回
  palette_type0(params = {}) {
    params = {
      diff: 10,     // 1回で進む差
      count: 10,    // これで割った数だけ1度に進む
      alpha: 0.5,   // 不透明度
      ...params,
    }
    const e = params
    const base_color = PaletteInfo.fetch("info").base_color.alpha(e.alpha)
    const base_hue = base_color.get("hsl.h")
    const list = []
    for (let i = 0; i < e.count; i++) {
      const c = base_color.set('hsl.h', base_hue + e.diff * i).css()
      list.push(c)
    }
    return list
  },

  // range / count ずつ count 回
  palette_type1(params = {}) {
    params = {
      range: 180,   // hueの幅
      count: 10,    // これで割った数だけ1度に進む
      alpha: 0.4,   // 不透明度
      ...params,
    }
    const e = params
    const base_color = PaletteInfo.fetch("success").base_color.alpha(e.alpha)
    const base_hue = base_color.get("hsl.h")
    const list = []
    for (let i = 0; i < e.count; i++) {
      const c = base_color.set('hsl.h', base_hue + e.range * i / e.count).css()
      list.push(c)
    }
    return list
  },

  // 2点の色を (count - 1) 分割して count 回
  // 必ず2点の色になる
  palette_type2(params = {}) {
    params = {
      range: 1.0,   // この幅を
      count: 2,     // この個数で割った数だけ一度に進む
      colors: [
        // PaletteInfo.fetch("success").alpha(0.4),
        // PaletteInfo.fetch("danger").alpha(1),
        PaletteInfo.fetch("info").alpha(0.5),
        PaletteInfo.fetch("primary").alpha(0.5),
      ],
      ...params,
    }
    const e = params
    const f = chroma.scale(e.colors)
    const list = []
    let d = 0
    if (e.count >= 2) {
      d = e.range / (e.count - 1)
    }
    for (let i = 0; i < e.count; i++) {
      const c = f(i * d).css()
      list.push(c)
    }
    return list
  },

  palette_type3(params = {}) {
    params = {
      alpha: 0.5,   // 不透明度
      ...params,
    }
    const e = params
    const base_color = PaletteInfo.fetch("info").base_color.alpha(e.alpha)
    return [
      base_color.css(),
      base_color.set('hsl.s', 0).set('hsl.l', 0.8).css(),
    ]
  },

  palette_type4(params = {}) {
    params = {
      alpha: 0.5,
      ...params,
    }
    const e = params
    const base_color = PaletteInfo.fetch("info").base_color.alpha(e.alpha)
    return base_color.css()
  },

  palette_transparent(params = {}) {
    params = {
      alpha: 0,
      ...params,
    }
    const e = params
    const base_color = PaletteInfo.fetch("primary").base_color.alpha(e.alpha)
    return base_color.css()
  },

  palette_of(params = {}) {
    params = {
      alpha: 0.5,
      key: "danger",
      ...params,
    }
    const e = params
    const base_color = PaletteInfo.fetch(e.key).base_color.alpha(e.alpha)
    return base_color.css()
  },

}
