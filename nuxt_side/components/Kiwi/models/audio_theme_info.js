import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import dayjs from "dayjs"
import { GX } from "@/components/models/gx.js"

export class AudioThemeInfo extends ApplicationMemoryRecord {
  static field_label = "BGM"
  static field_message = ""

  static get define() {
    // ../../../../../bioshogi/lib/bioshogi/audio_theme_info.rb
    return [
      { key: "is_audio_theme_custom",        name: "カスタム",      environment: ["development", "staging", "production"], sample_source: null,                                                                                                                                                                                                                                            desc: "BGMなし、または自分でｱｯﾌﾟﾛｰﾄﾞする場合", },
      { key: "is_audio_theme_diamond_shark", name: "Diamond Shark", environment: ["development", "staging", "production"], sample_source: require("../../../../../bioshogi/lib/bioshogi/assets/audios/diamond_shark.m4a"), source_url: "https://www.youtube.com/watch?v=JZMHhmDwauk",  author: "27Corazones Beats", bpm: 180.0,  audio_part_a_duration: 3*60+12, audio_part_a_loop: false, desc: "", },
      { key: "is_audio_theme_ds3812",        name: "Three Keys",    environment: ["development", "staging", "production"], sample_source: require("../../../../../bioshogi/lib/bioshogi/assets/audios/ds3812.m4a"),        source_url: "https://dova-s.jp/bgm/play3812.html",          author: "Khaim",             bpm: null,   audio_part_a_duration:  237.72, audio_part_a_loop: false, desc: "", },
      { key: "is_audio_theme_ds3479",        name: "Blue Ever",     environment: ["development", "staging", "production"], sample_source: require("../../../../../bioshogi/lib/bioshogi/assets/audios/ds3479.m4a"),        source_url: "https://dova-s.jp/bgm/play3479.html",          author: "Khaim",             bpm: 120.02, audio_part_a_duration:  56.03,  audio_part_a_loop: true,  desc: "", },
    ]
  }

  get duration_sec() {
    if (this.audio_part_a_duration) {
      return GX.number_round(this.audio_part_a_duration)
    }
  }

  get duration_mmss() {
    if (this.audio_part_a_duration) {
      return dayjs.unix(this.duration_sec).format("mm:ss")
    }
  }

  get loop_support_p() {
    return this.audio_part_a_loop
  }

  get introduction() {
    const a = []
    if (this.author) {
      a.push(`${this.author}さんの`)
    }
    if (this.name) {
      a.push(this.name)
    }
    return a.join("")
  }
}
