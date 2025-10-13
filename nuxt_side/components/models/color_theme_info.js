import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import { GX } from "@/components/models/gx.js"
import QueryString from "query-string"

const SAMPLE_SFEN = "position sfen l+n1g1g1n+l/1ks2r1+r1/1pppp1bpp/p2+b+sp+p2/9/P1P1+SP1PP/1+P+BPP1P2/1BK1GR1+R1/+L+NSG3NL b R2B3G4S5N11L99Pr2b3g4s5n11l99p 1"

export class ColorThemeInfo extends ApplicationMemoryRecord {
  static field_label = "配色"
  static field_message = ""
  static image_scale = 1.0

  static get define() {
    return [
      { key: "is_color_theme_modern",   name: "モダン",          },
      { key: "is_color_theme_real",   name: "リアル",          },
      { key: "is_color_theme_piyo",   name: "ぴよ将棋風",      },
      { key: "is_color_theme_club24", name: "将棋倶楽部24風" , },
      { key: "is_color_theme_paper",  name: "紙面風",          },
      { key: "is_color_theme_shape",  name: "紙面風(☖付き)",  },
    ]
  }

  thumbnail_url(context) {
    return QueryString.stringifyUrl({
      url: context.$config.MY_SITE_URL + "/share-board.png",
      query: {
        body: SAMPLE_SFEN,
        color_theme_key: this.key,
        width: 1920 * this.constructor.image_scale,
        height: 1080 * this.constructor.image_scale,
        color_theme_preview_image_use: "true", // これを取ると実際に生成する,
      },
    })
  }

  get introduction() {
    return this.name
  }
}
