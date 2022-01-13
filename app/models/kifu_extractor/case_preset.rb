# 手合割
# rails r 'puts KifuExtractor.extract("二枚落ち")'
module KifuExtractor
  class CasePreset < Extractor
    def resolve
      if e = Bioshogi::PresetInfo.lookup(item.source)
        @body = e.to_position_sfen
      end
    end
  end
end
