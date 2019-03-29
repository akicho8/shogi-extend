module Swars
  class DirtyPresetInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "__handicap_embed__0", __swars_key: "Hirate",   beauty_key: "平手",     },
      { key: "__handicap_embed__1", __swars_key: "Kyo",      beauty_key: "香落ち",   },
      { key: "__handicap_embed__2", __swars_key: "Kaku",     beauty_key: "角落ち",   },
      { key: "__handicap_embed__3", __swars_key: "Hisha",    beauty_key: "飛車落ち", },
      { key: "__handicap_embed__4", __swars_key: "HishaKyo", beauty_key: "飛香落ち", },
      { key: "__handicap_embed__5", __swars_key: "Two",      beauty_key: "二枚落ち", },
      { key: "__handicap_embed__6", __swars_key: "Four",     beauty_key: "四枚落ち", },
      { key: "__handicap_embed__7", __swars_key: "Six",      beauty_key: "六枚落ち", },
      { key: "__handicap_embed__8", __swars_key: "Eight",    beauty_key: "八枚落ち", },
      { key: "__handicap_embed__9", __swars_key: "Ten",      beauty_key: "十枚落ち", },
    ]

    def real_preset_info
      Bioshogi::PresetInfo.fetch(beauty_key)
    end
  end
end
