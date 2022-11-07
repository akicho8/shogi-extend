# 戦法・囲い・手筋などの名前
# rails r 'puts KifuExtractor.extract("嬉野流")'
module KifuExtractor
  class CaseContentTactic < Extractor
    def resolve
      source_expand.each do |str|
        if e = Bioshogi::TacticInfo.flat_lookup(str)
          @body = e.sample_kif_file.read
          break
        end
      end
    end

    private

    def source_expand
      [
        # "アヒル戦法"
        item.source,
        # "アヒル" → "アヒル戦法"
        item.source + "戦法",
        item.source + "囲い",
        item.source + "流",
        # "都成流戦法" → "都成流"
        item.source.remove(/戦法\z/),
        item.source.remove(/囲い\z/),
        item.source.remove(/流\z/),
        # 特殊
        item.source.sub(/向かい飛車/, "向飛車"), # "向かい飛車" → "向かい飛車"
        item.source.sub(/向飛車/, "向かい飛車"), # "向飛車" → "向かい飛車"
      ]
    end
  end
end
