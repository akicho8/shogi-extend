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

    def convert(source)
      parse(source) || source
    end

    def parse(source)
      new(source).parse
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
  def parse
    extract_body
    if @body
      Bioshogi::Parser.parse(@body, {
          :skill_monitor_enable           => false,
          :skill_monitor_technique_enable => false,
          :candidate_enable               => false,
          :validate_enable                => true,
        }).mediator_run_once
      body
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
      :extract_body_if_swars_url,
      :extract_body_if_kiousen_url,
      :extract_body_if_kento_url,
      :extract_body_if_shogidb2_url,
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

  def extract_body_if_swars_url
    if url_type?
      if key = Swars::Battle.battle_key_extract(@source)
        Swars::Battle.single_battle_import(key: key)
        if battle = Swars::Battle.find_by(key: key)
          @body = battle.kifu_body
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

  def extract_body_if_shogidb2_url
    if uri = extracted_uri
      if uri.host.end_with?("shogidb2.com")
        sfen = nil
        if uri.fragment
          sfen = Rack::Utils.unescape(uri.fragment)
        end
        if uri.query
          hash = Rack::Utils.parse_query(uri.query)
          sfen = hash["sfen"]
        end
        if sfen.present?
          @body = ["position", "sfen", sfen].join(" ")
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
