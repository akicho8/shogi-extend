# HTMLのなかにある kif へのリンクを探す
# rails r 'puts KifuExtractor.extract("https://www.shogi-extend.com/kif_included.html")'
# rails r 'puts KifuExtractor.extract("http://member.meijinsen.jp/pay/kif/meijinsen/2014/01/10/A1/6622.html")'
module KifuExtractor
  class CaseUrlTrustworthyFileSearchInHtml < Base
    def resolve
      if v = uri_fetched_content
        item = Item.new(v)
        if uri = item.all_extract_kif_uris.first
          @body = human_very_dirty_kif_fetch_and_clean(uri)
        end
      end
    end
  end
end
