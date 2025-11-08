import { RegexpBuilder } from "@/components/models/regexp_builder.js"

export const RegexpSet = {
  COMMON_SAFE_CHAR: RegexpBuilder.build([
    "half_width_alpha",
    "half_width_number",
    "half_width_kana",
    "full_width_alpha",
    "full_width_number",
    "full_width_kana",
    "full_width_kanji",
    "full_width_hiragana",
  ]),

  COMMON_NUMBER: RegexpBuilder.build([
    "half_width_number",
    "full_width_number",
  ]),
}
