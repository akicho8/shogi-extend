# スポニチサイトの中身
# rails r 'puts KifuExtractor.extract("(１)▲２六歩[13]　(２)△３四歩[35]")'
module KifuExtractor
  class CaseSponichiContent < Extractor
    include CaseSponichiMethods

    def resolve
      sponichi_scan(item)
    end
  end
end
