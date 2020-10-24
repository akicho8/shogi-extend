# shogidb2 の URL から棋譜を抽出
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

# URLが含まれるテキストをSFENに変換する
#  sfen = UrlEmbedKifuParser.parse("https://www.kento-shogi.com/?moves=5g5f.8c8d.7g7f.8d8e.8h7g.6a5b.2h5h.7a6b.7i6h.5a4b.6h5g.4b3b.5i4h.1c1d.1g1f.6c6d.5f5e.6b6c.5g5f.3a4b.4h3h.4c4d.3h2h.4b4c.3i3h.7c7d.9g9f.9c9d.9i9g.3c3d.4g4f.2b3c.5h9h.8e8f.8g8f.8b8d.6i5h.3b2b.9f9e.9d9e.9g9e.P%2A9d.9e9d.9a9d.P%2A9e.7d7e.7f7e.3c2d.5h4g.4a3b.9e9d.5c5d.L%2A8e.5d5e.5f5e.P%2A7f.7g9i.8d8e.8f8e.2d3c.4f4e.L%2A8f.5e4d.4c4d.9i4d.8f8i%2B.S%2A4a.S%2A4c.4a3b%2B.4c3b.9d9c%2B.3c4d.4e4d.L%2A4e.4d4c%2B.4e4g%2B.4c3b.2b3b.3h4g.7f7g%2B.9c8c.B%2A6e.9h9b%2B.6e4g%2B.L%2A4h.P%2A4f.4h4g.4f4g%2B.P%2A4h.S%2A5h.4i3i.L%2A3h.3i3h.4g3h.2h3h.S%2A1g.B%2A5d.G%2A4c.5d4c%2B.3b4c.L%2A4f.N%2A4d.2i1g.B%2A5g.S%2A5e.G%2A5d.R%2A4a.4c3c.5e4d#34")
#  assert { sfen == "position startpos moves 5g5f 8c8d 7g7f 8d8e 8h7g 6a5b 2h5h 7a6b 7i6h 5a4b 6h5g 4b3b 5i4h 1c1d 1g1f 6c6d 5f5e 6b6c 5g5f 3a4b 4h3h 4c4d 3h2h 4b4c 3i3h 7c7d 9g9f 9c9d 9i9g 3c3d 4g4f 2b3c 5h9h 8e8f 8g8f 8b8d 6i5h 3b2b 9f9e 9d9e 9g9e P*9d 9e9d 9a9d P*9e 7d7e 7f7e 3c2d 5h4g 4a3b 9e9d 5c5d L*8e 5d5e 5f5e P*7f 7g9i 8d8e 8f8e 2d3c 4f4e L*8f 5e4d 4c4d 9i4d 8f8i+ S*4a S*4c 4a3b+ 4c3b 9d9c+ 3c4d 4e4d L*4e 4d4c+ 4e4g+ 4c3b 2b3b 3h4g 7f7g+ 9c8c B*6e 9h9b+ 6e4g+ L*4h P*4f 4h4g 4f4g+ P*4h S*5h 4i3i L*3h 3i3h 4g3h 2h3h S*1g B*5d G*4c 5d4c+ 3b4c L*4f N*4d 2i1g B*5g S*5e G*5d R*4a 4c3c 5e4d" }
class UrlEmbedKifuParser
  def self.http_get_body(url)
    connection = Faraday.new do |builder|
      builder.response :follow_redirects # リダイレクト先をおっかける
      builder.adapter :net_http
    end

    response = connection.get(url)
    s = response.body

    s = s.toutf8
    s = s.gsub(/\\n/, "") # 棋王戦のKIFには備考に改行コードではない '\n' という文字が入っていることがある
  end

  URL_CHECK_HEAD_LINES = 4

  attr_accessor :dirty_text
  attr_accessor :body

  delegate :http_get_body, to: "self.class"

  def self.convert(dirty_text)
    parse(dirty_text) || dirty_text
  end

  def self.parse(dirty_text)
    new(dirty_text).parse
  end

  def initialize(dirty_text)
    @dirty_text = dirty_text.to_s
  end

  # 抽出した本体をSFENに変換してエラーにならないなら「SFENではなく」本体を返す
  def parse
    extract_body
    if body
      Bioshogi::Parser.parse(body).to_sfen
      body
    end
  rescue Bioshogi::BioshogiError => error
    Rails.logger.info(error)
    nil
  end

  def extract_body
    if e = Bioshogi::TacticInfo.flat_lookup(@dirty_text.strip)
      @body = e.sample_kif_file.read
      return
    end

    if e = Bioshogi::PresetInfo.lookup(@dirty_text.strip)
      @body = e.to_position_sfen
      return
    end

    if dirty_text.strip.lines.count <= URL_CHECK_HEAD_LINES && dirty_text.match?(%{^https?://})
      # ウォーズのURL
      if key = Swars::Battle.battle_key_extract(dirty_text)
        Swars::Battle.single_battle_import(key: key)
        if battle = Swars::Battle.find_by(key: key)
          @body = battle.kifu_body
          return
        end
      end

      url = URI.extract(dirty_text, ["http", "https"]).first
      if url
        uri = URI(url)

        # 棋王戦
        # http://live.shogi.or.jp/kiou/kifu/45/kiou202002010101.html
        if uri.host == "live.shogi.or.jp"
          uri.path = uri.path.sub(/html\z/, "kif")
          @body = http_get_body(uri.to_s)
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
            @body = ["position", "sfen", sfen].join(" ")
            return
          end
        end

        if uri.host == "www.kento-shogi.com"
          @body = KentoUrlInfo.parse(url).to_sfen
          return
        end

        # http://live.shogi.or.jp/kiou/kifu/45/kiou202002010101.kif
        @body = http_get_body(url)
      end
    end
  end
end
