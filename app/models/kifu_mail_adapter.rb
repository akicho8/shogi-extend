# for KifuMailer
class KifuMailAdapter
  attr_accessor :params

  def initialize(params)
    @params = params
  end

  def subject
    str = []
    str << "棋譜メール"
    str
  end

  def body
    [
      {
        "再生用URL" => params[:url] || kifu_parser.to_share_board_url,
        "棋譜(KI2)" => kifu_parser.to_ki2,
      }.collect { |k, v| "▼#{k}\n#{v}".strip }.join("\n\n")
    ]
  end

  def kifu_parser
    @kifu_parser ||= KifuParser.new(params.merge(source: params[:sfen]))
  end

  def attachment_filename
    s = [
      Time.current.strftime("%Y%m%d%H%M%S"),
      normalized_title,
    ].compact.join("_")
    s + ".kif"
  end

  def normalized_title
    if s = params[:title].presence
      s = s.gsub(/\P{Graph}/, "") # 見えない文字は削除
      s = s.gsub(/\p{Punct}/, "") # 記号は削除
    end
  end
end
