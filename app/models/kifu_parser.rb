class KifuParser
  KENTO_URL     = "https://www.kento-shogi.com"
  SHOGIWARS_URL = "https://shogiwars.heroz.jp/games"

  SHOGI_GUI_BUG_WORKAROUND = true

  attr_accessor :params

  def initialize(params = {})
    @params = params
  end

  def to_kif(*args)
    extra_header_part + core.to_kif(*args)
  end

  def to_ki2(*args)
    extra_header_part + core.to_ki2(*args)
  end

  def to_csa(*args)
    core.to_csa
  end

  def to_sfen(*args)
    core.to_sfen(*args)
  end

  def to_bod(*args)
    core.to_bod(*args)
  end

  def to_png(*args)
    core.to_png(*args)
  end

  def to_gif(*args)
    if Rails.env.production?
      raise "いまのところproductionでのリアルタイムなGIF変換はサーバーが死ぬので禁止"
    end
    core.to_gif(*args)
  end

  def to_xxx(key = to_format, *args)
    public_send("to_#{key}", *args)
  end

  def to_s(*args)
    to_xxx(*args)
  end

  def as_json(*args)
    { body: to_s, turn_max: turn_max }
  end

  def to_all(*args)
    KifuFormatWithBodInfo.inject({}) { |a, e| a.merge(e.key => to_xxx(e.key, *args)) }
  end

  def all_kifs(*args)
    to_all(*args)
  end

  def to_a(*args)
    KifuFormatWithBodInfo.collect do |e|
      { key: e.key, name: e.name, value: to_xxx(e.key, *args) }
    end
  end

  # for app/models/battle_decorator/base.rb
  def core_parser
    core
  end

  private

  def to_format
    (params[:to_format].presence || "sfen").to_sym
  end

  def to_format_options
    {
      compact: true,
      no_embed_if_time_blank: true,
      # position_startpos_disabled: true, # "position startpos ..." 形式にはしない
    }
  end

  # > 棋譜コピーで貼り付けると「リモートサーバーがエラーを返しました」と出る
  # http://shogi-gui.bbs.fc2.com/
  # ↑に対応するため * を入れている
  def extra_header_part
    if params[:extra_header_part_skip]
      return ""
    end

    extra_header.collect { |k, v| "#{header_key_prefix}#{k}：#{v}\n" }.join
  end

  def header_key_prefix
    if SHOGI_GUI_BUG_WORKAROUND
      "*"
    end
  end

  def extra_header
    {
      "詳細URL"  => show_url,           # たくさん埋めなくてもこれ一つで済む
      "ぴよ将棋" => show_url("piyo_shogi"),
      "KENTO"    => show_url("kento"),
      # "検索URL" => search_url,
      # "KENTO"      => kento_url,
      # "共有将棋盤" => share_board_url,
      # "対局URL"    => swars_battle_url,
    }.reject { |k, v| v.blank? }
  end

  def show_url(path = nil)
    if v = swars_battle_key
      UrlProxy.wrap2(["/swars/battles/#{v}", path].compact.join("/"))
    end
  end

  def search_url
    if v = swars_battle_key
      UrlProxy.wrap2("/swars/search?query=#{v}")
    end
  end

  def kento_url
    m = core.mediator
    h = {}
    if m.initial_state_board_sfen != "startpos"
      h[:initpos] = m.initial_state_board_sfen.remove(/^sfen\s*/)
    end
    if m.hand_logs.present?
      h[:moves] = m.hand_logs.collect(&:to_sfen).join(".")
    end
    "#{KENTO_URL}/?#{h.to_query}"
  end

  def share_board_url
    UrlProxy.wrap2({
        path: "/share-board",
        query: {
          body: @core.to_sfen,
          abstract_viewpoint: :black,
        },
      })
  end

  def swars_battle_url
    if v = swars_battle_key
      "#{SHOGIWARS_URL}/#{v}"
    end
  end

  def core
    @core ||= Bioshogi::Parser.parse(source, parser_options)
  end

  def turn_max
    core.mediator.turn_info.turn_offset
  end

  def source
    @source ||= params[:source] || UrlEmbedKifuParser.convert(any_source) # URLや戦術名→棋譜
  end

  def any_source
    @any_source ||= params[:any_source]
  end

  def parser_options
    options = {
      :typical_error_case            => :embed,
      :support_for_piyo_shogi_v4_1_5 => false,
    }
    if to_format == :bod
      options[:turn_limit] = turn_limit
    end
    [
      :candidate_enable,
      :validate_enable,
    ].each do |key|
      if params.has_key?(key)
        options[key] = true_or_false(params[key])
      end
    end
    options
  end

  def swars_battle_key
    params[:swars_battle_key].presence
  end

  def turn_limit
    if v = params[:turn].presence
      v.to_i
    end
  end

  def true_or_false(v)
    v.to_s.in?(["true", "1"])
  end
end
