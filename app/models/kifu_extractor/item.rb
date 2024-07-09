module KifuExtractor
  class Item
    BASIC_EXTENTIONS = [:kif, :kifu, :ki2, :ki2u, :csa, :sfen, :bod]
    BASIC_EXTENTIONS_REGEXP = /\.(?:#{BASIC_EXTENTIONS.join("|")})\b/io

    attr_accessor :source

    def initialize(source, options = {})
      @source = source.to_s.toutf8.strip # source が Shift_JIS だった場合に strip できないため toutf8 が必要
      @options = {
        url_check_head_lines: 4,
      }.merge(options)
    end

    def url_type?
      if @source.lines.count <= @options[:url_check_head_lines]
        @source.match?(/^http/) # KIFのヘッダに含まれるURLへのマッチを避けるため行頭から始まっている条件が重要
      end
    end

    def extracted_uri
      @extracted_uri ||= yield_self do
        if url_type?
          all_extract_uris.first
        end
      end
    end

    def extracted_kif_uri
      if v = extracted_uri
        if kif_uri?(v)
          v
        end
      end
    end

    def uri_fetched_content
      @uri_fetched_content ||= yield_self do
        if uri = extracted_uri
          WebAgent2.fetch(uri)
        end
      end
    end

    # URI.extract で抽出したものの中には不正なURL(例えば "http:/http://example.com" )
    # も含まれているためさらに URI(url).host があるかどうかまで確認する必要がある
    def all_extract_uris
      @all_extract_uris ||= yield_self do
        av = URI.extract(@source, ["http", "https"])
        av = av.collect { |e| URI(e) }
        av.find_all(&:host)
      end
    end

    # URI.extract(@source, ["http", "https"]) では逆に正しくマッチできないので置き換えてはいけない
    # 例えば "url: 'http://example.com/xxx.kif'," には "http://example.com/xxx.kif'," がマッチしてしまう
    # だからか URI.extract は公式で非推奨になっている
    def all_extract_kif_uris
      @all_extract_kif_uris ||= @source.scan(%r{https?://.*?#{BASIC_EXTENTIONS_REGEXP}})
    end

    def kif_uri?(uri)
      if uri.host # すでにチェックしているので取ってもいいが単体で使うかもしれないので入れておく
        if uri.path
          uri.path.match?(/#{BASIC_EXTENTIONS_REGEXP}\z/io)
        end
      end
    end
  end
end
