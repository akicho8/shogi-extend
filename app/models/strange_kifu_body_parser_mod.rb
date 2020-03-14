# shogidb2 の URL から棋譜を抽出
#
#
# require "uri"
# require "rack"
#
# url1 = "https://shogidb2.com/games/018d3d1ee6594c34c677260002621417c8f75221#lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F2P6%2FPP1PPPPPP%2F1B5R1%2FLNSGKGSNL%20w%20-%202"
# url2 = "https://shogidb2.com/board?sfen=lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F2P6%2FPP1PPPPPP%2F1B5R1%2FLNSGKGSNL%20w%20-%202&moves=-3334FU%2B2726FU-8384FU%2B2625FU-8485FU%2B5958OU-4132KI%2B6978KI-8586FU%2B8786FU-8286HI%2B2524FU-2324FU%2B2824HI-8684HI%2B0087FU-0023FU%2B2428HI-2233KA%2B5868OU-7172GI%2B9796FU-3142GI%2B8833UM"
#
# # URI.extract(url1, ["http", "https"]).first # => "https://shogidb2.com/games/018d3d1ee6594c34c677260002621417c8f75221#lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F2P6%2FPP1PPPPPP%2F1B5R1%2FLNSGKGSNL%20w%20-%202"
#
# uri = URI(url1)
# uri.scheme   # => "https"
# uri.userinfo # => nil
# uri.host     # => "shogidb2.com"
# uri.port     # => 443
# uri.path     # => "/games/018d3d1ee6594c34c677260002621417c8f75221"
# uri.query    # => nil
# uri.fragment # => "lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F2P6%2FPP1PPPPPP%2F1B5R1%2FLNSGKGSNL%20w%20-%202"
# uri.to_s     # => "https://shogidb2.com/games/018d3d1ee6594c34c677260002621417c8f75221#lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F2P6%2FPP1PPPPPP%2F1B5R1%2FLNSGKGSNL%20w%20-%202"
# if uri.fragment
#   s = Rack::Utils.unescape(uri.fragment) # => "lnsgkgsnl/1r5b1/ppppppppp/9/9/2P6/PP1PPPPPP/1B5R1/LNSGKGSNL w - 2"
#   ["position sfen", s].join(" ")         # => "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/2P6/PP1PPPPPP/1B5R1/LNSGKGSNL w - 2"
# end
#
# uri = URI(url2)
# uri.scheme   # => "https"
# uri.userinfo # => nil
# uri.host     # => "shogidb2.com"
# uri.port     # => 443
# uri.path     # => "/board"
# uri.query    # => "sfen=lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F2P6%2FPP1PPPPPP%2F1B5R1%2FLNSGKGSNL%20w%20-%202&moves=-3334FU%2B2726FU-8384FU%2B2625FU-8485FU%2B5958OU-4132KI%2B6978KI-8586FU%2B8786FU-8286HI%2B2524FU-2324FU%2B2824HI-8684HI%2B0087FU-0023FU%2B2428HI-2233KA%2B5868OU-7172GI%2B9796FU-3142GI%2B8833UM"
# uri.fragment # => nil
# uri.to_s     # => "https://shogidb2.com/board?sfen=lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F2P6%2FPP1PPPPPP%2F1B5R1%2FLNSGKGSNL%20w%20-%202&moves=-3334FU%2B2726FU-8384FU%2B2625FU-8485FU%2B5958OU-4132KI%2B6978KI-8586FU%2B8786FU-8286HI%2B2524FU-2324FU%2B2824HI-8684HI%2B0087FU-0023FU%2B2428HI-2233KA%2B5868OU-7172GI%2B9796FU-3142GI%2B8833UM"
#
# hash = Rack::Utils.parse_query(uri.query) # => {"sfen"=>"lnsgkgsnl/1r5b1/ppppppppp/9/9/2P6/PP1PPPPPP/1B5R1/LNSGKGSNL w - 2", "moves"=>"-3334FU+2726FU-8384FU+2625FU-8485FU+5958OU-4132KI+6978KI-8586FU+8786FU-8286HI+2524FU-2324FU+2824HI-8684HI+0087FU-0023FU+2428HI-2233KA+5868OU-7172GI+9796FU-3142GI+8833UM"}
# ["position sfen", hash["sfen"]].join(" ") # => "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/2P6/PP1PPPPPP/1B5R1/LNSGKGSNL w - 2"

module StrangeKifuBodyParserMod
  extend ActiveSupport::Concern

  URL_CHECK_HEAD_LINES = 4

  private

  def url_in_kifu_body
    if kifu_body.strip.lines.count <= URL_CHECK_HEAD_LINES && kifu_body.match?(%{^https?://})

      # ウォーズ
      if key = Swars::Battle.battle_key_extract(kifu_body)
        Swars::Battle.single_battle_import(key: key)
        if battle = Swars::Battle.find_by(key: key)
          self.kifu_body = battle.kifu_body
          return
        end
      end

      url = URI.extract(kifu_body, ["http", "https"]).first
      if url
        uri = URI(url)

        # 棋王戦
        # http://live.shogi.or.jp/kiou/kifu/45/kiou202002010101.html
        if uri.host == "live.shogi.or.jp"
          uri.path = uri.path.sub(/html\z/, "kif")
          self.kifu_body = http_get_body(uri.to_s)
          return
        end

        if uri.host == "shogidb2.com"
          sfen = nil
          if uri.fragment
            sfen = Rack::Utils.unescape(uri.fragment) # => "lnsgkgsnl/1r5b1/ppppppppp/9/9/2P6/PP1PPPPPP/1B5R1/LNSGKGSNL w - 2"
          end
          if uri.query
            hash = Rack::Utils.parse_query(uri.query) # => {"sfen"=>"lnsgkgsnl/1r5b1/ppppppppp/9/9/2P6/PP1PPPPPP/1B5R1/LNSGKGSNL w - 2", "moves"=>"-3334FU+2726FU-8384FU+2625FU-8485FU+5958OU-4132KI+6978KI-8586FU+8786FU-8286HI+2524FU-2324FU+2824HI-8684HI+0087FU-0023FU+2428HI-2233KA+5868OU-7172GI+9796FU-3142GI+8833UM"}
            sfen = hash["sfen"]
          end
          if sfen.present?
            self.kifu_body = ["position", "sfen", sfen].join(" ")
            return
          end
        end

        # https://www.kento-shogi.com/?moves=5g5f.8c8d.7g7f.8d8e.8h7g.6a5b.2h5h.7a6b.7i6h.5a4b.6h5g.4b3b.5i4h.1c1d.1g1f.6c6d.5f5e.6b6c.5g5f.3a4b.4h3h.4c4d.3h2h.4b4c.3i3h.7c7d.9g9f.9c9d.9i9g.3c3d.4g4f.2b3c.5h9h.8e8f.8g8f.8b8d.6i5h.3b2b.9f9e.9d9e.9g9e.P%2A9d.9e9d.9a9d.P%2A9e.7d7e.7f7e.3c2d.5h4g.4a3b.9e9d.5c5d.L%2A8e.5d5e.5f5e.P%2A7f.7g9i.8d8e.8f8e.2d3c.4f4e.L%2A8f.5e4d.4c4d.9i4d.8f8i%2B.S%2A4a.S%2A4c.4a3b%2B.4c3b.9d9c%2B.3c4d.4e4d.L%2A4e.4d4c%2B.4e4g%2B.4c3b.2b3b.3h4g.7f7g%2B.9c8c.B%2A6e.9h9b%2B.6e4g%2B.L%2A4h.P%2A4f.4h4g.4f4g%2B.P%2A4h.S%2A5h.4i3i.L%2A3h.3i3h.4g3h.2h3h.S%2A1g.B%2A5d.G%2A4c.5d4c%2B.3b4c.L%2A4f.N%2A4d.2i1g.B%2A5g.S%2A5e.G%2A5d.R%2A4a.4c3c.5e4d#34
        # https://www.kento-shogi.com/?initpos=lnsgkgsnl%2F9%2Fppppppppp%2F9%2F9%2F9%2FPPPPPPPPP%2F1B5R1%2FLNSGKGSNL%20w%20-%201&moves=7a6b.7g7f.5c5d.2g2f.6b5c.3i4h.4a3b.4i5h.6c6d.5i6h.7c7d.7i7h.5a6b.2f2e.6b6c.7h7g.6a6b.7g6f.8a7c.9g9f.9c9d.7f7e.6d6e.6f7g.7d7e.7g8f.5c6d.5g5f.3a4b.4h5g.4b5c.5g4f.8c8d.6g6f.7e7f.2e2d.2c2d.2h2d.P%2A2c.2d2e.8d8e.8f9g.6e6f.8h6f.4c4d.8g8f.3c3d.8f8e.2a3c.2e2h.7f7g%2B.8i7g.P%2A7f.9g8f.7f7g%2B.8f7g.6d6e.6f4h.P%2A8f.P%2A6f.6e5f.P%2A5g.4d4e.5g5f.4e4f.4g4f.8f8g%2B.7g7f.N%2A6d.7f7e.6d5f.6h5g.5f4h%2B.5g4h.8g7g.P%2A7d.7c8e.P%2A2d.2c2d.2h2d.P%2A2c.2d2h.P%2A4e.4f4e.P%2A4f.S%2A4d.3c4e.4d5c%2B.6c5c.P%2A2d.B%2A5f.S%2A3f.S%2A4g.3f4g.S%2A5g.5h5g.4e5g%2B.4h3h.4f4g%2B.3h2g.4g3h.2h3h.5f3h%2B.2g3h.R%2A4h.3h2g.S%2A3h.2g1f.4h4f%2B.S%2A3f.1c1d.S%2A2f.G%2A1e.2f1e.1d1e#115
        if uri.host == "www.kento-shogi.com"
          if uri.query
            hash = Rack::Utils.parse_query(uri.query)
            # hash # => {"initpos"=>"lnsgkgsnl/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1", "moves"=>"7a6b.7g7f.5c5d.2g2f.6b5c.3i4h.4a3b.4i5h.6c6d.5i6h.7c7d.7i7h.5a6b.2f2e.6b6c.7h7g.6a6b.7g6f.8a7c.9g9f.9c9d.7f7e.6d6e.6f7g.7d7e.7g8f.5c6d.5g5f.3a4b.4h5g.4b5c.5g4f.8c8d.6g6f.7e7f.2e2d.2c2d.2h2d.P*2c.2d2e.8d8e.8f9g.6e6f.8h6f.4c4d.8g8f.3c3d.8f8e.2a3c.2e2h.7f7g+.8i7g.P*7f.9g8f.7f7g+.8f7g.6d6e.6f4h.P*8f.P*6f.6e5f.P*5g.4d4e.5g5f.4e4f.4g4f.8f8g+.7g7f.N*6d.7f7e.6d5f.6h5g.5f4h+.5g4h.8g7g.P*7d.7c8e.P*2d.2c2d.2h2d.P*2c.2d2h.P*4e.4f4e.P*4f.S*4d.3c4e.4d5c+.6c5c.P*2d.B*5f.S*3f.S*4g.3f4g.S*5g.5h5g.4e5g+.4h3h.4f4g+.3h2g.4g3h.2h3h.5f3h+.2g3h.R*4h.3h2g.S*3h.2g1f.4h4f+.S*3f.1c1d.S*2f.G*1e.2f1e.1d1e"}
            parts = ["position"]
            if v = hash["initpos"].presence
              parts.push("sfen", v)
            else
              parts.push("startpos")
            end
            if v = hash["moves"].presence
              parts.push("moves", v.gsub(".", " "))
            end
            if v = uri.fragment.presence
              # v = 手数
            end
            self.kifu_body = parts.join(" ")
            return
          end
        end

        # http://live.shogi.or.jp/kiou/kifu/45/kiou202002010101.kif
        self.kifu_body = http_get_body(url)
      end
    end
  end
end
