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
      url = URI.extract(kifu_body, ["http", "https"]).first
      uri = URI(url)
      sfen = nil
      case
      when uri.host == "shogidb2.com"
        case
        when uri.fragment
          sfen = Rack::Utils.unescape(uri.fragment) # => "lnsgkgsnl/1r5b1/ppppppppp/9/9/2P6/PP1PPPPPP/1B5R1/LNSGKGSNL w - 2"
        when uri.query
          hash = Rack::Utils.parse_query(uri.query) # => {"sfen"=>"lnsgkgsnl/1r5b1/ppppppppp/9/9/2P6/PP1PPPPPP/1B5R1/LNSGKGSNL w - 2", "moves"=>"-3334FU+2726FU-8384FU+2625FU-8485FU+5958OU-4132KI+6978KI-8586FU+8786FU-8286HI+2524FU-2324FU+2824HI-8684HI+0087FU-0023FU+2428HI-2233KA+5868OU-7172GI+9796FU-3142GI+8833UM"}
          sfen = hash["sfen"]
        end
        if sfen
          self.kifu_body = ["position", "sfen", sfen].join(" ")
        end
      else
        self.kifu_body = open(url, &:read).toutf8
      end
    end
  end
end
