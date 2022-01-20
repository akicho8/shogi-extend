# スポニチサイトの中身
# rails r 'puts KifuExtractor.extract("(１)▲２六歩[13]　(２)△３四歩[35]")'
module KifuExtractor
  class CaseContentSponichi < Extractor
    include SponichiSupport

    def resolve
      s = item.source
      s = s.remove(/\p{blank}/)
      if s.match?(/^\(.+?\)[▲△].+?\[.+?\]/)
        sponichi_scan(item)
      end
    end
  end
end
