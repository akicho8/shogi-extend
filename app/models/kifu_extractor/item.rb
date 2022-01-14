module KifuExtractor
  class Item
    BASIC_EXTENTIONS = [:kif, :kifu, :ki2, :ki2u, :csa, :sfen, :bod]
    BASIC_EXTENTIONS_REGEXP = /\.(?:#{BASIC_EXTENTIONS.join("|")})\b/io

    attr_accessor :source

    def initialize(source, options = {})
      @source = source.to_s.strip
      @options = {
        url_check_head_lines: 4,
      }.merge(options)
    end

    def url_type?
      if @source.lines.count <= @options[:url_check_head_lines]
        @source.match?(/^http/) # KIFのヘッダに含まれるURLへのマッチを避けるため行頭から始まっている条件が重要
      end
    end

    def extracted_url
      @extracted_url ||= yield_self do
        if url_type?
          all_extract_urls.first
        end
      end
    end

    def extracted_uri
      @extracted_uri ||= yield_self do
        if extracted_url
          URI(extracted_url)
        end
      end
    end

    def extracted_kif_url
      if v = extracted_url
        if kif_url?(v)
          v
        end
      end
    end

    def fetched_content
      @fetched_content ||= yield_self do
        if url = extracted_url
          WebAgent.fetch(url)
        end
      end
    end

    def all_extract_urls
      @all_extract_urls ||= URI.extract(@source, ["http", "https"])
    end

    # URI.extract(@source, ["http", "https"]) では逆に正しくマッチできないので置き換えてはいけない
    # 例えば "url: 'http://example.com/xxx.kif'," には "http://example.com/xxx.kif'," がマッチしてしまう
    # だからか URI.extract は公式で非推奨になっている
    def all_extract_kif_urls
      @all_extract_urls ||= @source.scan(%r{https?://.*?#{BASIC_EXTENTIONS_REGEXP}})
    end

    def kif_url?(url)
      uri = URI(url)
      if uri.path
        uri.path.match?(/#{BASIC_EXTENTIONS_REGEXP}\z/io)
      end
    end
  end
end
