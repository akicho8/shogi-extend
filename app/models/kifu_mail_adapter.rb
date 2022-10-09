# |---------------------|
# | public              |
# |---------------------|
# | subject             |
# | body                |
# | attachment_filename |
# | attachment_body     |
# |---------------------|

# for KifuMailer
class KifuMailAdapter
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
    hv["棋譜再生"]        = kifu_parser.to_share_board_tiny_url
    hv["KENTO"]           = kifu_parser.to_kento_tiny_url
    hv["share_board_url"] = params[:app_urls][:share_board_url]
    hv["piyo_url"]        = params[:app_urls][:piyo_url]
    hv["piyo_url2"]       = TinyUrl.safe_create(params[:app_urls][:piyo_url])
    hv["kento_url"]       = params[:app_urls][:kento_url]
    hv["棋譜(KI2)"]       = kifu_parser.to_ki2
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
end
