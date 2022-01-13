# 戦法・囲い・手筋などの名前
# rails r 'puts KifuExtractor.extract("嬉野流")'
module KifuExtractor
  class CaseTactic < Extractor
    def resolve
      if e = Bioshogi::TacticInfo.flat_lookup(item.source)
        @body = e.sample_kif_file.read
      end
    end
  end
end
