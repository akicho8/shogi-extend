# |---------------------|
# | public              |
# |---------------------|
# | subject             |
# | body                |
# | attachment_filename |
# | attachment_body     |
# | mail_to_address     |
# | main_icon           |
# |---------------------|

# for KifuMailer
class KifuMailAdapter
  def self.mock_params
    {
      :source => "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 6i5h 4a5b 4i4h 6a6b",
      :turn   => 2,
      :title  => "(title)",
      :black  => "(black)",
      :white  => "(white)",
      :other  => "(other)",
      :member => "(member)",
      :viewpoint => "white",
      :sb_judge_key => "win",  # win, lose, none
      :__debug_app_urls__ => {
        :share_board_url => "http://localhost:3000/share-board?body=position.sfen.lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F9%2FPPPPPPPPP%2F1B5R1%2FLNSGKGSNL.b.-.1.moves.6i5h.4a5b.4i4h.6a6b&turn=4&viewpoint=black",
        :piyo_url        => "piyoshogi://?viewpoint=black&num=4&url=http://localhost:3000/share-board.kif?body=position.sfen.lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F9%2FPPPPPPPPP%2F1B5R1%2FLNSGKGSNL.b.-.1.moves.6i5h.4a5b.4i4h.6a6b&turn=4&viewpoint=black",
        :kento_url       => "https://www.kento-shogi.com/?initpos=lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F9%2FPPPPPPPPP%2F1B5R1%2FLNSGKGSNL+b+-+1&viewpoint=black&moves=6i5h.4a5b.4i4h.6a6b#4",
      },
      :user   => User.first || User.create!,
    }
  end

  attr_accessor :params

  def initialize(params)
    @params = params
  end

  def subject
    str = []
    str << params[:title]
    str << "棋譜"
    str.join(" ")
  end

  def body
    hv = {}
    if false
      hv["再生"] = kifu_parser.to_share_board_short_url
    else
      hv["再生"]  = kifu_parser.to_share_board_url
    end
    if Rails.env.local?
      hv["*再生URLの元"]     = kifu_parser.to_share_board_url
      hv["*KENTO"]           = kifu_parser.to_kento_url
      hv["*KENTO (ShortUrl)"] = kifu_parser.to_kento_short_url
    end
    hv["棋譜"] = kifu_parser.to_ki2
    if e = params[:__debug_app_urls__]
      e.each do |k, v|
        hv["*#{k}"] = v
        hv["*#{k} (ShortUrl)"] = ShortUrl[v]
      end
    end
    hv.collect { |k, v| "▼#{k}\n#{v}".strip }.join("\n\n")
  end

  def attachment_filename
    s = [
      Time.current.strftime("%Y%m%d%H%M%S"),
      normalized_title,
    ].compact.join("_")
    s + ".kif"
  end

  def attachment_body
    kifu_parser.to_kif
  end

  def mail_to_address
    if user
      "#{user.name} <#{user.email}>"
      # else
      #   AppConfig[:admin_email]
    end
  end

  def main_icon
    SbJudgeInfo.fetch(params[:sb_judge_key]).icon
  end

  private

  def kifu_parser
    @kifu_parser ||= KifuParser.new(params)
  end

  def normalized_title
    if s = params[:title].presence
      s = s.gsub(/\P{Graph}/, "") # 見えない文字は削除
      s = s.gsub(/\p{Punct}/, "") # 記号は削除
    end
  end

  def user
    params[:user]
  end
end
