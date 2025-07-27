# 戦法・囲い・手筋などの名前
# rails r 'puts KifuExtractor.extract("嬉野流")'
module KifuExtractor
  class CaseContentTactic < Base
    def resolve
      if e = Bioshogi::Analysis::TagIndex.fuzzy_lookup(item.source)
        @body = e.static_kif_file.read
      end
    end
  end
end
