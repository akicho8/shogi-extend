# バトル show のHTMLに埋め込まれている JSON っぽいものを取り出す
# rails r 'puts KifuExtractor.extract("https://shogidb2.com/games/0e0f7f6518bca14e5b784015963d5f38795c86a7")'
#
# 局面を動かすとこのURLの後ろに #xxx で SFEN が入る
# これをもともとは読み取っていたが利用者が欲しいのは fragment ではなく元の棋譜と思われるため fragment は無視する
#
module KifuExtractor
  class CaseShogidb2Show < Extractor
    def resolve
      if url = extracted_url
        if url.include?("shogidb2.com/games/")
          if md = fetched_content.match(/(var|const|let)\s*data\s*=\s*(?<json_str>\{.*\})/)
            json_params = JSON.parse(md["json_str"], symbolize_names: true)
            @body = Shogidb2Parser.parse(json_params)
          end
        end
      end
    end
  end
end
