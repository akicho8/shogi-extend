# スポニチサイト
# rails r 'puts KifuExtractor.extract("https://www.sponichi.co.jp/entertainment/news/2022/01/18/kiji/20220118c00041S01002000c.html")'
module KifuExtractor
  class CaseUrlSponichi < Extractor
    include SponichiSupport

    def resolve
      if uri = extracted_uri
        if uri.host.include?("sponichi.co.jp")
          if v = uri_fetched_content
            sponichi_scan(Item.new(v))
          end
        end
      end
    end
  end
end
