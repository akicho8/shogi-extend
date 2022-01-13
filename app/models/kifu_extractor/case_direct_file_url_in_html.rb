# HTMLのなかにある kif へのリンクを探す
# rails r 'puts KifuExtractor.extract("https://www.shogi-extend.com/kif_included.html")'
# rails r 'puts KifuExtractor.extract("http://member.meijinsen.jp/pay/kif/meijinsen/2014/01/10/A1/6622.html")'
module KifuExtractor
  class CaseDirectFileUrlInHtml < Extractor
    def resolve
      if v = fetched_content
        item = Item.new(v)
        if url = item.all_extract_kif_urls.first
          if v = WebAgent.fetch(url)
            @body = v.toutf8
          end
        end
      end
    end
  end
end
