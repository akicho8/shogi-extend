class KifuExtractor
  class << self
    def http_get_body(url)
      connection = Faraday.new do |builder|
        builder.response :follow_redirects # リダイレクト先をおっかける
        builder.adapter :net_http
      end

      response = connection.get(url)
      s = response.body

      s = s.toutf8
      s = s.gsub(/\\n/, "") # 棋王戦のKIFには備考に改行コードではない '\n' という文字が入っていることがある
    end

    def extract(*args)
      new(*args).extract
    end
  end

  attr_accessor :source
  attr_accessor :body

  delegate :http_get_body, to: "self.class"

  def initialize(source, options = {})
    @options = {
      url_check_head_lines: 4,
    }.merge(options)

    @source = source.to_s
  end

  # 抽出した本体が読み込めて最後の局面まで行けるなら「SFENではなく」本体を返す
  def extract
    extract_body
    if @body
      Bioshogi::Parser.parse(@body, {
          :skill_monitor_enable           => false,
          :skill_monitor_technique_enable => false,
          :candidate_enable               => false,
          :validate_enable                => false, # 二歩を許可するため
        }).mediator_run_once
      @body
    end
  rescue Bioshogi::BioshogiError => error
    SlackAgent.notify_exception(error)
    nil
  end

  private

  def extract_body
    @body = nil
    [
      :extract_body_if_tactic,
      :extract_body_if_preset,
      :extract_body_if_swars_games_url,
      :extract_body_if_swars_battles_self_url,
      :extract_body_if_kiousen_url,
      :extract_body_if_kento_url,
      :extract_body_if_shogidb2_games_embed_json,
      :extract_body_if_shogidb2_board_url_params,
      :extract_body_if_url_params,
      :extract_body_if_other_url,
    ].each do |e|
      send(e)
      if @body
        break
      end
    end
  end

  def extract_body_if_tactic
    if e = Bioshogi::TacticInfo.flat_lookup(@source.strip)
      @body = e.sample_kif_file.read
    end
  end

  def extract_body_if_preset
    if e = Bioshogi::PresetInfo.lookup(@source.strip)
      @body = e.to_position_sfen
    end
  end

  def extract_body_if_swars_games_url
    if url_type?
      if key = Swars::Battle.battle_key_extract(@source)
        Swars::Battle.single_battle_import(key: key)
        if battle = Swars::Battle.find_by(key: key)
          @body = battle.kifu_body
        end
      end
    end
  end

  # rails r 'puts KifuExtractor.extract("https://www.shogi-extend.com/swars/battles/htrns-kinakom0chi-20211217_190002/")'
  def extract_body_if_swars_battles_self_url
    if url_type?
      if uri = extracted_uri
        if md = uri.path.match(%r{/swars/battles/(?<battle_key>[\w-]+)})
          key = md["battle_key"]
          Swars::Battle.single_battle_import(key: key)
          if battle = Swars::Battle.find_by(key: key)
            @body = battle.kifu_body
          end
        end
      end
    end
  end

  # 棋王戦
  # http://live.shogi.or.jp/kiou/kifu/45/kiou202002010101.html
  def extract_body_if_kiousen_url
    if uri = extracted_uri
      if uri.host.end_with?("live.shogi.or.jp")
        uri.path = uri.path.sub(/html\z/, "kif")
        @body = http_get_body(uri.to_s)
      end
    end
  end

  # rails r 'puts KifuExtractor.extract("https://shogidb2.com/board?sfen=lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F2P6%2FPP1PPPPPP%2F1B5R1%2FLNSGKGSNL%20w%20-%202&moves=-3334FU%2B2726FU-8384FU%2B2625FU-8485FU%2B5958OU-4132KI%2B6978KI-8586FU%2B8786FU-8286HI%2B2524FU-2324FU%2B2824HI-8684HI%2B0087FU-0023FU%2B2428HI-2233KA%2B5868OU-7172GI%2B9796FU-3142GI%2B8833UM")'
  def extract_body_if_shogidb2_board_url_params
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

  # バトル show のHTMLに埋め込まれている JSON っぽいものを取り出す
  # rails r 'puts KifuExtractor.extract("https://shogidb2.com/games/0e0f7f6518bca14e5b784015963d5f38795c86a7")'
  #
  # 局面を動かすとこのURLの後ろに #xxx で SFEN が入る
  # これをもともとは読み取っていたが利用者が欲しいのは fragment ではなく元の棋譜と思われるため fragment は無視する
  def extract_body_if_shogidb2_games_embed_json
    if uri = extracted_uri
      if uri.host.end_with?("shogidb2.com")
        if uri.path.start_with?("/games/")
          str = http_get_body(extracted_url)
          if md = str.match(/(var|const|let)\s*data\s*=\s*(?<json_str>\{.*\})/)
            json_params = JSON.parse(md["json_str"], symbolize_names: true)
            @body = Shogidb2Parser.parse(json_params)
          end
        end
      end
    end
  end

  def extract_body_if_kento_url
    if uri = extracted_uri
      if uri.host.end_with?("kento-shogi.com")
        @body = KentoParamsParser.parse(uri.to_s).to_sfen
      end
    end
  end

  # https://example.com/?body=68S
  # https://example.com/?sfen=68S
  # https://example.com/#68S
  def extract_body_if_url_params
    if uri = extracted_uri
      if uri.query || uri.fragment
        hash = {}
        if uri.query
          hash.update(Rack::Utils.parse_query(uri.query))
        end
        if uri.fragment
          hash.update("__fragment__" => Rack::Utils.unescape(uri.fragment))
        end
        ["kif", "ki2", "csa", "sfen", "bod", "body", "kifu", "text", "content", "__fragment__"].each do |e|
          if v = hash[e]
            v = DotSfen.unescape(v.to_s)
            if v.present?
              if Bioshogi::Parser.accepted_class(v)
                @body = v
                break
              end
            end
          end
        end
      end
    end
  end

  # http://live.shogi.or.jp/kiou/kifu/45/kiou202002010101.kif
  def extract_body_if_other_url
    if url = extracted_url
      @body = http_get_body(url)
    end
  end

  def url_type?
    @source.strip.lines.count <= @options[:url_check_head_lines] && @source.match?(%{^https?://})
  end

  def extracted_url
    if url_type?
      @extracted_url ||= URI.extract(@source, ["http", "https"]).first
    end
  end

  def extracted_uri
    if extracted_url
      @uri ||= URI(extracted_url)
    end
  end
end
