# 将棋DB2 変化
# rails r 'puts KifuExtractor.extract("https://shogidb2.com/board?sfen=lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F2P6%2FPP1PPPPPP%2F1B5R1%2FLNSGKGSNL%20w%20-%202&moves=-3334FU%2B2726FU-8384FU%2B2625FU-8485FU%2B5958OU-4132KI%2B6978KI-8586FU%2B8786FU-8286HI%2B2524FU-2324FU%2B2824HI-8684HI%2B0087FU-0023FU%2B2428HI-2233KA%2B5868OU-7172GI%2B9796FU-3142GI%2B8833UM")'
module KifuExtractor
  class CaseShogidb2Board < Extractor
    def resolve
      if uri = extracted_uri
        if uri.host.end_with?("shogidb2.com")
          sfen = nil
          if uri.fragment
            sfen = Rack::Utils.unescape(uri.fragment)
          end
          if uri.query
            hv = Rack::Utils.parse_query(uri.query)
            sfen = hv["sfen"]
          end
          if sfen.present?
            @body = ["position", "sfen", sfen].join(" ")
          end
        end
      end
    end
  end
end
