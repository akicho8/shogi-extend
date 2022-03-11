# 王将戦
# rails r 'puts KifuExtractor.extract("https://mainichi.jp/oshosen-kifu/220109.html")'
module KifuExtractor
  class CaseUrlOushosen < Extractor
    def resolve
      if uri = extracted_uri
        if uri.to_s.include?("mainichi.jp/oshosen")
          if v = uri_fetched_content
            # url:"//cdn.mainichi.jp/vol1/shougi/kif/ousho202201090101_utf8.kif" にマッチ
            if md = v.match(%r{(?<url>//.*\.kif)\b})
              url = "https:" + md[:url]
              @body = human_very_dirty_kif_fetch_and_clean(url)
            end
          end
        end
      end
    end
  end
end
