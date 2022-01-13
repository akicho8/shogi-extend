# 王将戦
# rails r 'puts KifuExtractor.extract("https://mainichi.jp/oshosen-kifu/220109.html")'
module KifuExtractor
  class CaseOushosenUrl < Extractor
    def resolve
      if uri = extracted_uri
        if uri.host.end_with?("mainichi.jp")
          if v = fetched_content
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
