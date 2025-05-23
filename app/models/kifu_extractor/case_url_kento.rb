# KENTO
# rails r 'puts KifuExtractor.extract("https://www.kento-shogi.com/?moves=7g7f.3c3d.8h2b%2B#3")'
# rails r 'puts KifuExtractor.extract("https://www.kento-shogi.com/?branch=N%2A7e.7d7e.B%2A7d.8c9c.G%2A9b.9a9b.7d9b%2B.9c9b.6c7b.R%2A8b.G%2A8c.9b9a.7b8b.7c8b.R%2A9b&branchFrom=0&initpos=ln7%2F2g6%2F1ks%2BR5%2Fpppp5%2F9%2F9%2F%2Bp%2Bp%2Bp6%2F2%2Bp6%2FK1%2Bp6%20b%20NGB9p3l2n3s2gbr%201#6")'
# rails r 'puts KifuExtractor.extract("https://share.kento-shogi.com/?branch=N%2A7e.7d7e.B%2A7d.8c9c.G%2A9b.9a9b.7d9b%2B.9c9b.6c7b.R%2A8b.G%2A8c.9b9a.7b8b.7c8b.R%2A9b&branchFrom=0&initpos=ln7%2F2g6%2F1ks%2BR5%2Fpppp5%2F9%2F9%2F%2Bp%2Bp%2Bp6%2F2%2Bp6%2FK1%2Bp6%20b%20NGB9p3l2n3s2gbr%201#6")'
module KifuExtractor
  class CaseUrlKento < Base
    def resolve
      if uri = extracted_uri
        if uri.host.end_with?("kento-shogi.com")
          @body = Kento::Url[uri.to_s].to_sfen
        end
      end
    end
  end
end
