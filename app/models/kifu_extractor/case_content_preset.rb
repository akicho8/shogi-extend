# 手合割
# rails r 'puts KifuExtractor.extract("二枚落ち")'
module KifuExtractor
  class CaseContentPreset < Extractor
    def resolve
      if e = PresetInfo.lookup(item.source)
        @body = e.to_position_sfen
      end
    end
  end
end
