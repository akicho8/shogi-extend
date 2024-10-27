# 戦法・囲い・手筋などの名前
# rails r 'puts KifuExtractor.extract("嬉野流")'
module KifuExtractor
  class CaseContentTactic < Base
    def resolve
      if e = Bioshogi::Analysis::TacticInfo.fuzzy_flat_lookup(item.source)
        @body = e.main_reference_file.read
      end
    end
  end
end
