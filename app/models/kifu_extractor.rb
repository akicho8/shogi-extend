# テキストから棋譜を抽出する
#
#  KifuExtractor.extract("https://lishogi.org/ZY2Tyy2d") # => "開始日時：2021/12/06 04:37:40..."
#
#  与えられたテキスト自体が棋譜の場合はそれを返さないので注意
#  KifuExtractor.extract("76歩") # => nil
#
class KifuExtractor
  class << self
    def extract(*args)
      new(*args).extract
    end
  end

  BASIC_EXTENTIONS = [:kif, :kifu, :ki2, :ki2u, :csa, :sfen, :bod]
  OTHER_EXTENTIONS = [:text, :content, :contents, :body]

  attr_accessor :source
  attr_accessor :body

  def initialize(source, options = {})
    @options = {
      url_check_head_lines: 4,
    }.merge(options)

    @source = source.to_s.strip
  end

  def extract
    @body = nil
    [
      :extract_try_if_tactic,
      :extract_try_if_preset,
      :extract_try_if_lishogi,
      :extract_try_if_swars_games_url,
      :extract_try_if_swars_battles_self_url,
      :extract_try_if_kiousen_url,
      :extract_try_if_oushosen_url,
      :extract_try_if_kento_url,
      :extract_try_if_shogidb2_show,
      :extract_try_if_shogidb2_board,
      :extract_try_if_direct_file_url,
      :extract_try_if_url_params,
      :extract_try_if_direct_file_url_in_html,
      :extract_try_if_other_url,
    ].each do |e|
      send(e)
      if @body
        break
      end
    end
    @body
  end

  private

  # 戦法・囲い・手筋などの名前
  # rails r 'puts KifuExtractor.extract("嬉野流")'
  def extract_try_if_tactic
    if e = Bioshogi::TacticInfo.flat_lookup(@source)
      @body = e.sample_kif_file.read
    end
  end

  # 手合割
  # rails r 'puts KifuExtractor.extract("二枚落ち")'
  def extract_try_if_preset
    if e = Bioshogi::PresetInfo.lookup(@source)
      @body = e.to_position_sfen
    end
  end

  # 将棋ウォーズ本家対局URL
  # rails r 'puts KifuExtractor.extract("https://shogiwars.heroz.jp/games/Kato_Hifumi-SiroChannel-20200927_180900")'
  def extract_try_if_swars_games_url
    if url_type?
      if key = Swars::Battle.battle_key_extract(@source)
        Swars::Battle.single_battle_import(key: key)
        if battle = Swars::Battle.find_by(key: key)
          @body = battle.kifu_body
        end
      end
    end
  end

  # 将棋ウォーズ棋譜検索対局ページURL
  # rails r 'puts KifuExtractor.extract("https://www.shogi-extend.com/swars/battles/htrns-kinakom0chi-20211217_190002/")'
  def extract_try_if_swars_battles_self_url
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
  # rails r 'puts KifuExtractor.extract("http://live.shogi.or.jp/kiou/kifu/45/kiou202002010101.html")'
  # rails r 'puts KifuExtractor.extract("http://live.shogi.or.jp/kiou/kifu/45/kiou202002010101.kif")'
  def extract_try_if_kiousen_url
    if uri = extracted_uri
      if uri.host.end_with?("live.shogi.or.jp")
        uri.path = uri.path.sub(/html\z/, "kif")
        url = uri.to_s
        v = WebAgent.fetch(url)                  # 元が Shift_JIS なので内部で toutf8 している
        v = v.gsub(/\\n/, "")                    # '\n' の "文字" が入っているので削除
        v = Bioshogi::Parser.source_normalize(v) # 右端の全角スペースなどを削除
        v = v.remove(/^\*.*\R/)                  # 観戦記者の膨大なコメントを削除
        @body = v
      end
    end
  end

  # 棋王戦
  # rails r 'puts KifuExtractor.extract("https://mainichi.jp/oshosen-kifu/220109.html")'
  def extract_try_if_oushosen_url
    if uri = extracted_uri
      if uri.host.end_with?("mainichi.jp")
        if v = raw_content
          # url:"//cdn.mainichi.jp/vol1/shougi/kif/ousho202201090101_utf8.kif" にマッチ
          if md = v.match(%r{(?<url>//.*\.kif)\b})
            url = "https:" + md[:url]
            s = WebAgent.raw_fetch(url)
            s = s.toutf8              # 不正な文字が含まれる UTF-8 のため改めて UTF-8 にする
            s = s.gsub(/\s*\R/, "\n") # 改行も \r\n になっているため \n にする
            @body = s
          end
        end
      end
    end
  end

  # lishogi
  # rails r 'puts KifuExtractor.extract("https://lishogi.org/ZY2Tyy2dUdLl")'
  # rails r 'puts KifuExtractor.extract("https://lishogi.org/ZY2Tyy2d/sente")'
  # rails r 'puts KifuExtractor.extract("https://lishogi.org/ZY2Tyy2d/gote")'
  # rails r 'puts KifuExtractor.extract("https://lishogi.org/ZY2Tyy2d")'
  def extract_try_if_lishogi
    if uri = extracted_uri
      if uri.host.end_with?("lishogi.org")
        # https://lishogi.org/game/export/MDFjhiLq?csa=1&clocks=0
        if false
          # 仕様が不安定
          # 55将棋が読めない問題あり
          #
          # NOTE: user_agent が "Faraday v1" や通常のであれば kif を埋めない
          # wget や googlebot であれば kif が埋まっている
          doc = WebAgent.document(extracted_url, user_agent: "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)")
          if e = doc.at("div[class='kif']")
            @body = e.text
          end
        else
          # "id":"151jxej8"

          key_max = 8
          key = nil

          # sente gote がついたパスは正しいキーになっている
          # "https://lishogi.org/ZY2Tyy2d/sente" -> "ZY2Tyy2d"
          unless key
            if md = uri.path.match(%r{^/(?<key>\w+)/(sente|gote)})
              key = md["key"]
            end
          end

          # 棋譜ダウンロードURLも正しい
          # "https://lishogi.org/game/export/ZY2Tyy2d?csa=1&clocks=0"
          unless key
            if md = uri.path.match(%r{^/game/export/(?<key>\w+)})
              key = md["key"]
            end
          end

          # sente gote がついていないパスのキーは9文字以上ならきっと正しくない
          # 先頭の8文字だけが実際のキー
          # "https://lishogi.org/ZY2Tyy2dUdLl" => "ZY2Tyy2dUdLl" => "ZY2Tyy2d"
          unless key
            if md = uri.path.match(%r{^/(?<key>\w+)})
              key = md["key"].first(key_max)
            end
          end

          if key
            if false
              # CSAとして取得
              # 良い: 揺らぎがない
              # 悪い: 盤面が5五将棋の初期値になってない
              export_url = "https://lishogi.org/game/export/#{key}?csa=1&clocks=0"
              if v = WebAgent.raw_fetch(export_url)
                if Bioshogi::Parser::CsaParser.accept?(v)
                  v = v.strip # 無駄な改行があるので取る
                  @body = v
                end
              end
            else
              # KIFとして取得
              # 悪い: 揺らぐかもしれない
              # 悪い: Shift_JIS になっている
              # 悪い: 5五将棋の表記が "五々将棋" となっている
              export_url = "https://lishogi.org/game/export/#{key}?csa=0&clocks=0"
              if v = WebAgent.raw_fetch(export_url)
                if Bioshogi::Parser::KifParser.accept?(v)
                  v = v.toutf8  # Shift_JIS になっているため
                  v = v.strip   # 無駄な改行があるので取る
                  @body = v
                end
              end
            end
          end
        end
      end
    end
  end

  # 将棋DB2 変化
  # rails r 'puts KifuExtractor.extract("https://shogidb2.com/board?sfen=lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F2P6%2FPP1PPPPPP%2F1B5R1%2FLNSGKGSNL%20w%20-%202&moves=-3334FU%2B2726FU-8384FU%2B2625FU-8485FU%2B5958OU-4132KI%2B6978KI-8586FU%2B8786FU-8286HI%2B2524FU-2324FU%2B2824HI-8684HI%2B0087FU-0023FU%2B2428HI-2233KA%2B5868OU-7172GI%2B9796FU-3142GI%2B8833UM")'
  def extract_try_if_shogidb2_board
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
  def extract_try_if_shogidb2_show
    if uri = extracted_uri
      if uri.host.end_with?("shogidb2.com")
        if uri.path.start_with?("/games/")
          if md = raw_content.match(/(var|const|let)\s*data\s*=\s*(?<json_str>\{.*\})/)
            json_params = JSON.parse(md["json_str"], symbolize_names: true)
            @body = Shogidb2Parser.parse(json_params)
          end
        end
      end
    end
  end

  # KENTO
  # rails r 'puts KifuExtractor.extract("https://www.kento-shogi.com/?moves=7g7f.3c3d.8h2b%2B#3")'
  # rails r 'puts KifuExtractor.extract("https://www.kento-shogi.com/?branch=N%2A7e.7d7e.B%2A7d.8c9c.G%2A9b.9a9b.7d9b%2B.9c9b.6c7b.R%2A8b.G%2A8c.9b9a.7b8b.7c8b.R%2A9b&branchFrom=0&initpos=ln7%2F2g6%2F1ks%2BR5%2Fpppp5%2F9%2F9%2F%2Bp%2Bp%2Bp6%2F2%2Bp6%2FK1%2Bp6%20b%20NGB9p3l2n3s2gbr%201#6")'
  # rails r 'puts KifuExtractor.extract("https://share.kento-shogi.com/?branch=N%2A7e.7d7e.B%2A7d.8c9c.G%2A9b.9a9b.7d9b%2B.9c9b.6c7b.R%2A8b.G%2A8c.9b9a.7b8b.7c8b.R%2A9b&branchFrom=0&initpos=ln7%2F2g6%2F1ks%2BR5%2Fpppp5%2F9%2F9%2F%2Bp%2Bp%2Bp6%2F2%2Bp6%2FK1%2Bp6%20b%20NGB9p3l2n3s2gbr%201#6")'
  def extract_try_if_kento_url
    if uri = extracted_uri
      if uri.host.end_with?("kento-shogi.com")
        @body = KentoParamsParser.parse(uri.to_s).to_sfen
      end
    end
  end

  # https://example.com/?body=68S
  # https://example.com/?sfen=68S
  # https://example.com/#68S
  def extract_try_if_url_params
    if uri = extracted_uri
      if uri.query || uri.fragment
        hash = {}
        if uri.query
          hash.update(Rack::Utils.parse_query(uri.query))
        end
        if uri.fragment
          hash.update("__fragment__" => Rack::Utils.unescape(uri.fragment))
        end
        [*BASIC_EXTENTIONS, *OTHER_EXTENTIONS, "__fragment__"].each do |e|
          if v = hash[e.to_s]
            v = DotSfen.unescape(v.to_s)
            if v.present?
              if Bioshogi::Parser.accepted_class(v)
                if valid?(v)
                  @body = v
                  break
                end
              end
            end
          end
        end
      end
    end
  end

  # 拡張子まで指定されていたら信じるしかなかろう
  # rails r 'puts KifuExtractor.extract("https://www.shogi-extend.com/example_shift_jis.kif")'
  def extract_try_if_direct_file_url
    if url = extracted_url
      if kif_url?(url)
        if v = raw_content
          @body = v.toutf8
        end
      end
    end
  end

  # HTMLのなかにある kif へのリンクを探す
  # rails r 'puts KifuExtractor.extract("https://www.shogi-extend.com/kif_included.html")'
  def extract_try_if_direct_file_url_in_html
    if v = raw_content
      urls = extract_urls_from(v)
      if url = urls.find { |e| kif_url?(e) }
        if v = WebAgent.fetch(url)
          @body = v.toutf8
        end
      end
    end
  end

  # 間違えて入力された得体の知れないURLは巨大なHTMLになっていることが多いため
  # タグを取ったり文字コードを安全にしたりして死なないようにする
  # rails r 'puts KifuExtractor.extract("https://www.shogi-extend.com/")'
  # rails r 'puts KifuExtractor.extract("https://lishogi.org/")'
  def extract_try_if_other_url
    if v = raw_content
      v = v.toutf8
      v = ApplicationRecord.strip_tags(v)
      v = v.strip
      if v.present?
        if Bioshogi::Parser.accepted_class(v)
          if valid?(v)
            @body = v
          end
        end
      end
    end
  end

  def url_type?
    if @source.lines.count <= @options[:url_check_head_lines]
      # KIFのヘッダーに含まれるURLを無視させるため行頭から http が始まっているか？の条件が重要
      @source.match?(/^http/)
    end
  end

  def extracted_url
    if url_type?
      @extracted_url ||= extract_urls_from(@source).first
    end
  end

  def extracted_uri
    if extracted_url
      @uri ||= URI(extracted_url)
    end
  end

  def raw_content
    if url = extracted_url
      @raw_content ||= WebAgent.fetch(url)
    end
  end

  def extract_urls_from(str)
    URI.extract(str, ["http", "https"])
  end

  def valid?(str)
    begin
      info = Bioshogi::Parser.parse(str, {
          :skill_monitor_enable           => false,
          :skill_monitor_technique_enable => false,
          :candidate_enable               => false,
          :validate_enable                => false, # 二歩を許可するため
        })
      info.mediator_run_once
      true
    rescue Bioshogi::BioshogiError => error
      SlackAgent.notify_exception(error)
      false
    end
  end

  def kif_url?(url)
    URI(url).path.match?(/\.(#{BASIC_EXTENTIONS.join("|")})\z/io)
  end
end
