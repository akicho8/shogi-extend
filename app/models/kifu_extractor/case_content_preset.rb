# 手合割
# rails r 'puts KifuExtractor.extract("二枚落ち")'
module KifuExtractor
  class CaseContentPreset < Base
    def resolve
      if e = PresetInfo.lookup(item.source)
        @body = e.to_short_sfen
      end
    end
  end
end
