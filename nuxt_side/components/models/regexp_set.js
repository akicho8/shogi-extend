import { RegexpBuilder } from "@/components/models/regexp_builder.js"

export const RegexpSet = {
  ROOM_KEY_SAFE_CHAR: RegexpBuilder.build([
    "half_width_alpha",
    "half_width_number",
    "full_width_kanji",
    "full_width_hiragana",
    "full_width_hyphen_wave",
    "half_width_hyphen_underscore",
  ]),

  HANDLE_NAME_SAFE_CHAR: RegexpBuilder.build([
    "half_width_alpha",
    "half_width_number",
    "full_width_kanji",
    "full_width_hiragana",
    "full_width_hyphen_wave",
  ]),

  COMMON_NUMBER: RegexpBuilder.build([
    "half_width_number",
  ]),

  COMMON_GRADE: (() => {
    const numbers = RegexpBuilder.string([
      "half_width_number",
      "full_width_kanji_number",
    ])
    return new RegExp(`[初${numbers}]+[段級]`)
  })(),
}
