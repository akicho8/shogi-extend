import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class BoardPresetInfo extends ApplicationMemoryRecord {
  static field_label = "ゴースト"
  static field_message = ""

  static get define() {
    return [
      { key: "無", sfen: "position sfen 9/9/9/9/9/9/9/9/9 b - 1",                                                      message: "なし",                   },
      { key: "平", sfen: "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1",              message: "平手",                   },
      { key: "四", sfen: "position sfen ln1g1g1nl/1ks2r3/1pppp1bpp/p3spp2/9/P1P1SP1PP/1P1PP1P2/1BK1GR3/LNSG3NL b - 1", message: "右四間飛車 vs 四間飛車", },
      { key: "矢", sfen: "position sfen ln5nl/1r4gk1/2sp1gsp1/p1pbppp1p/1p5P1/P1PPPBP1P/1PSG1PS2/1KG4R1/LN5NL b - 1",  message: "矢倉 (脇システム)",      },
    ]
  }

  get talk_message() {
    return this.message
  }
}
